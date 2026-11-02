namespace AllocationDeliveryDomain.Endpoint.Validation
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using BusinessLogic.Enricher;
    using BusinessLogic.Mapper;
    using BusinessLogic;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ReportedActualsLoadedHandler : IHandleMessages<ReportedActualsLoadedCommand>
    {
        private readonly IActualEnricher _actualEnricher;
        private readonly IActualValidator _actualValidator;
        private readonly IMultiSourceActualRepository _multiSourceActualRepository;
        private readonly IMapper<EnrichedReportedActual, ContractAllocationActualsType> _mapper;
        private readonly IActualsAuditMapper _actualsAuditMapper;
        private readonly ILogger _logger;
        private readonly IMonitoringDeliverableStore _deliverableStore;
        private readonly ICurrentViewActualsComponent _currentViewActualsComponent;
        private readonly IGenericSubmissionEnricher _genericSubmissionEnricher;
        private readonly IFundingStreamConfigurationStore _fundingConfigurationStore;
        private readonly IProcessedMessageRepository _processedMessageRepository;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ReportedActualsLoadedHandler(
            IActualEnricher actualEnricher,
            IActualValidator actualValidator,
            IMultiSourceActualRepository multiSourceActualRepository,
            ILogger logger,
            IMapper<EnrichedReportedActual, ContractAllocationActualsType> mapper,
            IActualsAuditMapper actualsAuditMapper,
            IMonitoringDeliverableStore deliverableStore,
            ICurrentViewActualsComponent currentViewActualsComponent,
            IGenericSubmissionEnricher genericSubmissionEnricher,
            IFundingStreamConfigurationStore fundingConfigurationStore,
            IProcessedMessageRepository processedMessageRepository,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _actualEnricher = actualEnricher;
            _actualValidator = actualValidator;
            _multiSourceActualRepository = multiSourceActualRepository;
            _logger = logger;
            _mapper = mapper;
            _actualsAuditMapper = actualsAuditMapper;
            _deliverableStore = deliverableStore;
            _currentViewActualsComponent = currentViewActualsComponent;
            _genericSubmissionEnricher = genericSubmissionEnricher;
            _fundingConfigurationStore = fundingConfigurationStore;
            _processedMessageRepository = processedMessageRepository;
            _sessionConnectionFactory = sessionConnectionFactory;
        }


        public async Task Handle(ReportedActualsLoadedCommand message, IMessageHandlerContext context)
        {
            string messageId = context.MessageId;

            _logger.LogInformation(
                AllocationDeliverDomainEventLoggingId.AllocationActualVerificationStarted,
                "ReportedActualsLoaded started for FundingStreamPeriodCode {0} with messageId {1}",
                message.FundingStreamPeriodCode, messageId);

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            if (_processedMessageRepository.Add(messageId, connectionInfo))
            {
                // Get allocation actuals
                IReadOnlyCollection<ReportedActual> actuals = _multiSourceActualRepository.GetReportedActuals(message.PartitionKeys, message.SummarisedActualOrgFspGroupKeys, connectionInfo);

                _logger.LogInformation(
                    AllocationDeliverDomainEventLoggingId.ReportedActualsLoadedDetails,
                    "ReportedActualsLoaded - Processing actuals started for {0} actuals with total value {1}. First actual details are : {2}, messageId {3} ",
                    actuals.Count,
                    actuals.Sum(a => a.ActualValue),
                    actuals.FirstOrDefault()?.ToString(), messageId);

                FundingStreamPeriod fundingStreamPeriod = _fundingConfigurationStore.GetFundingStreamPeriod(message.FundingStreamPeriodCode, connectionInfo);

                // Check for FSP being within an optional ActivityCloseDate
                if (_actualValidator.IsCalcDateAfterFspActivityCloseDate(fundingStreamPeriod.Code, connectionInfo))
                {
                    _logger.LogError(
                        AllocationDeliverDomainEventLoggingId.ReportActualsGivenFSPActivityCloseDateBeforeCalculationDate,
                        $"Actuals have arrived for FundingStreamPeriod {fundingStreamPeriod.Code} after the ActivityCloseDate. Actuals processing has stopped for partition key(s) {string.Join(", ", message.PartitionKeys)}, messageId {messageId}");
                    return;
                }

                // Enrich
                List<EnrichedReportedActual> enrichedActuals = _actualEnricher.Enrich(actuals, connectionInfo).ToList();

                if (enrichedActuals.Any())
                {
                    // Validate
                    List<EnrichedReportedActual> validActuals = _actualValidator.GetValidActuals(enrichedActuals, connectionInfo);

                    // Zeroize missing actuals
                    FundingStreamZeroisationBehaviour zeroisationBehaviour = fundingStreamPeriod.GetZeroisationBehaviour();
                    bool hasZeroisationBehaviour = zeroisationBehaviour != FundingStreamZeroisationBehaviour.NotSet;

                    if (hasZeroisationBehaviour)
                    {
                        validActuals = _genericSubmissionEnricher.AddMissingActualsWithZeroValues(validActuals,
                            zeroisationBehaviour, connectionInfo);
                    }

                    if (fundingStreamPeriod.PersistCurrentActualsState)
                    {
                        // EOP processing
                        validActuals =
                            _currentViewActualsComponent.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(
                                validActuals, connectionInfo);
                    }

                    // Audit
                    IEnumerable<AllocationDeliverablePeriodActualAudit> auditActuals = _actualsAuditMapper.Map(validActuals, connectionInfo);
                    _deliverableStore.StoreActualsAudit(auditActuals, connectionInfo);

                    // Map and Aggregate to output type
                    List<ContractAllocationActualsType> contractAllocationActuals = _mapper.Map(validActuals).ToList();

                    _logger.LogInformation(
                        AllocationDeliverDomainEventLoggingId.AllocationActualVerificationCompleted,
                        "Publishing {0} actuals with total value {1}, for Allocation(s): {2}, messageId {3}",
                        validActuals.Count(),
                        validActuals.Sum(a => a.ActualValue),
                        string.Join(
                            ", ",
                            contractAllocationActuals.Select(a => a.ContractAllocationNumber)), messageId);
                    if (validActuals.None())
                    {
                        _logger.LogInformation(
                            AllocationDeliverDomainEventLoggingId.AllocationActualVerificationCompletedWithNoValidActuals,
                            $"Not found any valid actuals message: {message}, connectionString: {connectionInfo.Connection.ConnectionString}");
                    }

                    foreach (ContractAllocationActualsType contractAllocationActual in contractAllocationActuals)
                    {
                        await context.Publish(new AllocationActualsVerified {AllocationActuals = contractAllocationActual})
                            .ConfigureAwait(false);
                    }
                }
                else
                {
                    _logger.LogInformation(AllocationDeliverDomainEventLoggingId.NoActiveActuals,
                        "No actuals were published. This may be because they were associated with inactive allocations, messageId {0}", messageId);
                }
            }
            else
            {
                _logger.LogInformation(AllocationDeliverDomainEventLoggingId.ReportedActualsLoadedDuplicate,
                    "ReportedActualsLoaded has already processed this message. FundingStreamPeriodCode {0}, MessageId {1}", 
                    message.FundingStreamPeriodCode, messageId);
            }
        }
    }
}
