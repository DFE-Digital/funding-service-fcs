namespace PerformanceManagementDomain.ReconciliationPublication
{
    using System.Threading.Tasks;
    using Infrastructure;
    using NServiceBus;
    using Repositories;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using SFA.FCT.PerformanceManagementDomain.Common.Repositories;

    public class InitiatePublishOfFundingClaimReconciliationHandler : IHandleMessages<InitiatePublishOfFundingClaimReconciliationCommand>
    {
        private readonly ILogger _logger;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;
        private readonly IDateProvider _dateProvider;
        private readonly IFcrPublisher _fcrPublisher;
        private readonly IClaimReconciliationBehaviourRepository _claimReconciliationBehaviourRepository;
        private readonly IFundingClaimReconciliationQueryRepository _fundingClaimReconciliationRepository;
        private readonly IClaimReconciliationPublicationExceptionRepository _claimReconciliationPublicationExceptionRepository;
        private readonly IClaimReconciliationReferenceDataReconProfilingRepository _claimReconciliationReferenceDataReconProfilingRepository;

        public InitiatePublishOfFundingClaimReconciliationHandler(
            ILogger logger,
            ISessionConnectionFactory sessionConnectionFactory,
            IDateProvider dateProvider,
            IFcrPublisher fcrPublisher,
            IClaimReconciliationBehaviourRepository claimReconciliationBehaviourRepository,
            IFundingClaimReconciliationQueryRepository fundingClaimReconciliationRepository,
            IClaimReconciliationPublicationExceptionRepository claimReconciliationPublicationExceptionRepository, 
            IClaimReconciliationReferenceDataReconProfilingRepository claimReconciliationReferenceDataReconProfilingRepository)
        {
            _logger = logger;
            _sessionConnectionFactory = sessionConnectionFactory;
            _dateProvider = dateProvider;
            _fcrPublisher = fcrPublisher;
            _claimReconciliationBehaviourRepository = claimReconciliationBehaviourRepository;
            _fundingClaimReconciliationRepository = fundingClaimReconciliationRepository;
            _claimReconciliationPublicationExceptionRepository = claimReconciliationPublicationExceptionRepository;
            _claimReconciliationReferenceDataReconProfilingRepository = claimReconciliationReferenceDataReconProfilingRepository;
        }

        public async Task Handle(InitiatePublishOfFundingClaimReconciliationCommand message, IMessageHandlerContext context)
        {
            _logger.LogInformation(PerformanceManagementLoggingId.StartInitiatePublishFundingClaimReconciliation, "Beginning handler to initiate publish of funding claim reconciliation: {0}", message);
            
            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            FundingClaimReconciliation fundingClaimReconciliation = _fundingClaimReconciliationRepository.GetFundingClaimReconciliation(message.FundingClaimReconciliationId);

            bool isAfterPublicationCloseDate = await _claimReconciliationBehaviourRepository.IsAfterPublicationCloseDate(
                connectionInfo,
                fundingClaimReconciliation.GetClaimCollectionCode(),
                fundingClaimReconciliation.AllocationGroup.AllocationGroupCode,
                _dateProvider.GetDate(connectionInfo)).ConfigureAwait(false);

            if (isAfterPublicationCloseDate)
            {
                _logger.LogInformation(PerformanceManagementLoggingId.InitiatePublishOfFundingClaimHasOccurredAfterCloseDate, "We are beyond the close date of funding claim reconciliation: {0}", message);

                await context.Publish(new FundingClaimReconciliationFailedPublicationEvent
                {
                    FundingClaimReconciliationId = message.FundingClaimReconciliationId,
                    FundingClaimReconciliationName = message.Name,
                    OccurredOnDate = _dateProvider.GetDate(connectionInfo),
                    FailureReason =
                        $"There was a failure to publish the funding claim reconciliation for UKPRN: {fundingClaimReconciliation.Contractor.UKPRN}. This failure was caused by funding claim reconciliation publication activity having " +
                        $"closed for {fundingClaimReconciliation.AllocationGroup.AllocationGroupCode} {fundingClaimReconciliation.GetClaimCollectionCode()} reconciliations."
                }).ConfigureAwait(false);
            }
            else
            {
                bool isForManualPublication = await IsForManualPublication(connectionInfo, fundingClaimReconciliation)
                    .ConfigureAwait(false);
                FcrPublishResult publishResult = isForManualPublication ?
                    _fcrPublisher.PublishManually(connectionInfo, fundingClaimReconciliation) : await _fcrPublisher.PublishToFeed(connectionInfo, fundingClaimReconciliation);

                if (publishResult.IsAtomFeedDuplicate)
                {
                    _logger.LogError(PerformanceManagementLoggingId.InitiatePublishFundingClaimReconciliationError, $"A duplicate funding claim reconciliation has been received: {message}");
                }

                bool isClaimCollectionPayable = await IsClaimCollectionPayable(connectionInfo, fundingClaimReconciliation)
                    .ConfigureAwait(false);

                bool shouldStaggerPayments = await ShouldStaggerPayments(connectionInfo, fundingClaimReconciliation)
                    .ConfigureAwait(false);

                await context.Publish<FundingClaimReconciliationPublishedEvent>(e =>
                {
                    e.FundingClaimReconciliationId = message.FundingClaimReconciliationId;
                    e.FundingClaimReconciliationName = message.Name;
                    e.ContractInfo = publishResult.ContractInfo;
                    e.PublishedDate = publishResult.PublishedDate;
                    e.IsClaimCollectionPayable = isClaimCollectionPayable;
                    e.IsForManualPublication = isForManualPublication;
                    e.ShouldStaggerPayments = shouldStaggerPayments;
                }).ConfigureAwait(false);
            }

            _logger.LogInformation(PerformanceManagementLoggingId.FinishInitiatePublishFundingClaimReconciliation, "Finished initiating publish of funding claim reconciliation: {0}", message);
        }

        private async Task<bool> IsClaimCollectionPayable(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation)
        {
            return await _claimReconciliationBehaviourRepository.IsClaimCollectionPayable(
                connectionInfo,
                fundingClaimReconciliation.GetClaimCollectionCode(),
                fundingClaimReconciliation.AllocationGroup.AllocationGroupCode).ConfigureAwait(false);
        }

        private async Task<bool> IsForManualPublication(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation)
        {
            return await _claimReconciliationPublicationExceptionRepository.IsForManualPublication(
                connectionInfo,
                fundingClaimReconciliation.AllocationGroup.AllocationGroupCode,
                fundingClaimReconciliation.Contractor.UKPRN).ConfigureAwait(false);
        }

        private async Task<bool> ShouldStaggerPayments(ConnectionInfo connectionInfo, FundingClaimReconciliation fundingClaimReconciliation)
        {
            return await _claimReconciliationReferenceDataReconProfilingRepository.ShouldStaggerPayments(
                connectionInfo,
                fundingClaimReconciliation.GetFundingPeriod(),
                fundingClaimReconciliation.Contractor.UKPRN).ConfigureAwait(false);
        }
    }
}
