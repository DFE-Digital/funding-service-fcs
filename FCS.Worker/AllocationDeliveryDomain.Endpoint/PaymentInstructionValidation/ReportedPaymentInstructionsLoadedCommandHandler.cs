namespace AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Events;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentInstruction;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class ReportedPaymentInstructionsLoadedCommandHandler : IHandleMessages<ReportedPaymentInstructionsLoadedCommand>
    {
        private readonly ILogger _logger;
        private readonly IMultiSourceActualRepository _multiSourceActualRepository;
        private readonly IReportedPaymentEnricher _reportedPaymentEnricher;
        private readonly IPaymentInstructionValidator _paymentInstructionValidator;
        private readonly IPaymentInstructionAuditRepository _paymentInstructionAuditRepository;
        private readonly IDate _dateProvider;
        private readonly IMonitoringDeliverablesForAllocationService _monitoringDeliverablesForAllocationService;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ReportedPaymentInstructionsLoadedCommandHandler(ILogger logger,
            IMultiSourceActualRepository multiSourceActualRepository, 
            IReportedPaymentEnricher reportedPaymentEnricher, 
            IPaymentInstructionValidator paymentInstructionValidator, 
            IPaymentInstructionAuditRepository paymentInstructionAuditRepository, 
            IDate dateProvider, 
            IMonitoringDeliverablesForAllocationService monitoringDeliverablesForAllocationService, 
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _multiSourceActualRepository = multiSourceActualRepository;
            _reportedPaymentEnricher = reportedPaymentEnricher;
            _paymentInstructionValidator = paymentInstructionValidator;
            _paymentInstructionAuditRepository = paymentInstructionAuditRepository;
            _dateProvider = dateProvider;
            _monitoringDeliverablesForAllocationService = monitoringDeliverablesForAllocationService;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ReportedPaymentInstructionsLoadedCommand command, IMessageHandlerContext context)
        {
            _logger.LogInformation(
                AllocationDeliverDomainEventLoggingId.ReportedPaymentInstructionsLoadedProcessingStarted,
                $"ReportedPaymentInstructionsLoadedCommand processing started for {command}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            IReadOnlyCollection<ReportedActual> reportedPaymentInstructions =
                await _multiSourceActualRepository.GetReportedActuals(command.PartitionKey, command.SummarisedActualOrgFspGroupKey, connectionInfo);

            _monitoringDeliverablesForAllocationService.PopulateMissingValidDeliverables(
                actuals: reportedPaymentInstructions.ToList(),
                raiseMonitoringDeliverableAddedPostApprovalEvent: async monitoringDeliverableAdded =>
                {
                    await AddDeliverablePeriodsToPaymentScheduleForMissingMonitoringDeliverables(monitoringDeliverableAdded, context).ConfigureAwait(false);
                },
                connectionInfo: connectionInfo);

            IReadOnlyCollection<EnrichedReportedActual> enrichedReportedInstructions = _reportedPaymentEnricher.Enrich(connectionInfo, reportedPaymentInstructions);

            IReadOnlyCollection<EnrichedReportedActual> validReportedPaymentInstructions = GetValidPaymentInstructions(enrichedReportedInstructions);

            AuditPaymentInstructions(validReportedPaymentInstructions, connectionInfo);

            await PublishAllocationPaymentInstructionReceivedEvents(validReportedPaymentInstructions, context).ConfigureAwait(false);

            _logger.LogInformation(
                AllocationDeliverDomainEventLoggingId.ReportedPaymentInstructionsLoadedProcessingFinished,
                $"ReportedPaymentInstructionsLoadedCommand processing finished for {command}");
        }

        private void AuditPaymentInstructions(IEnumerable<EnrichedReportedActual> validReportedPaymentInstructions, ConnectionInfo connectionInfo)
        {
            IEnumerable<PaymentInstructionAudit> paymentInstructionAudits =
                validReportedPaymentInstructions.Select(pi => ReportedPaymentInstructionTransformer.TransformToPaymentInstructionAudit(pi, _dateProvider));
            _paymentInstructionAuditRepository.CreatePaymentInstructionAudits(paymentInstructionAudits, connectionInfo);
        }

        private IReadOnlyCollection<EnrichedReportedActual> GetValidPaymentInstructions(IReadOnlyCollection<EnrichedReportedActual> enrichedReportedInstructions)
        {
            enrichedReportedInstructions.ForEach(_paymentInstructionValidator.Validate);
            enrichedReportedInstructions.Where(pi => !pi.IsValid).ForEach(pi =>
            {
                _logger.LogInformation(
                    AllocationDeliverDomainEventLoggingId.ReportedPaymentInstructionValidationFailed,
                    $"Enriched reported payment instruction invalid: {pi}. Reason: {string.Join(",", pi.ValidationErrors)}");
            });

            return enrichedReportedInstructions.Where(pi => pi.IsValid).ToList();
        }

        private static async Task PublishAllocationPaymentInstructionReceivedEvents(
            IEnumerable<EnrichedReportedActual> validReportedPaymentInstructions, IMessageHandlerContext context)
        {
            IReadOnlyCollection<AllocationPaymentInstruction> allocationPaymentInstructions =
                ReportedPaymentInstructionTransformer.TransformToAllocationPaymentInstructions(validReportedPaymentInstructions);

            var publishTasks = allocationPaymentInstructions.Select(api =>
                context.Publish<IAllocationPaymentInstructionReceivedEvent>(e => { e.AllocationPaymentInstruction = api; }));

            await Task.WhenAll(publishTasks).ConfigureAwait(false);
        }

        private async Task AddDeliverablePeriodsToPaymentScheduleForMissingMonitoringDeliverables(
            MonitoringDeliverableAddedPostApprovalEvent monitoringDeliverableAdded, IMessageHandlerContext context)
        {
            // add the missing row(s) to the PaaS Payment Schedule for the periods held in MonitoringDeliverables.AllocationDeliverablePeriod
            var sendTasks = monitoringDeliverableAdded.Periods.Select(period => context.Send(new AddMissingDeliverablePeriodCommand
            {
                AllocationNumber = monitoringDeliverableAdded.AllocationNumber,
                VersionNumber = monitoringDeliverableAdded.ContractVersionNumber,
                DeliverableCode = monitoringDeliverableAdded.DeliverableCode,
                Period = period
            }));

            await Task.WhenAll(sendTasks).ConfigureAwait(false);
        }
    }
}