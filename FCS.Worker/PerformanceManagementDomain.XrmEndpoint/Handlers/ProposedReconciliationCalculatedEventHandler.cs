namespace PerformanceManagementDomain.XrmEndpoint.Handlers
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Logging;
    using System.Threading.Tasks;
    using Repositories;

    public class ProposedReconciliationCalculatedEventHandler : IHandleMessages<ProposedReconciliationCalculatedEvent>
    {
        private readonly ILogger _logger;
        private readonly IFundingClaimReconciliationCommandRepository _fundingClaimReconciliationCommandRepository;

        public ProposedReconciliationCalculatedEventHandler(ILogger logger, IFundingClaimReconciliationCommandRepository fundingClaimReconciliationCommandRepository)
        {
            _logger = logger;
            _fundingClaimReconciliationCommandRepository = fundingClaimReconciliationCommandRepository;
        }

        public Task Handle(ProposedReconciliationCalculatedEvent message, IMessageHandlerContext context)
        {
            var period = message.FundingClaimReconciliation.Period.PeriodTypeCode + message.FundingClaimReconciliation.Period.PeriodYear;
            var claimTypeName = message.FundingClaimReconciliation.ClaimType.ClaimTypeName;
            var allocationGroupName = message.FundingClaimReconciliation.AllocationGroup.AllocationGroupName;
            var ukprn = message.FundingClaimReconciliation.Contractor.UKPRN;

            _logger.LogInformation(PerformanceManagementLoggingId.StartPersistFundingClaimReconciliation,
                "Beginning handler to persist funding claim reconciliation to CRM. - " +
                $"Period: {period}, Claim Type: {claimTypeName}, Allocation Group Name: {allocationGroupName}, UKPRN: {ukprn}.");

            _fundingClaimReconciliationCommandRepository.CreateFundingClaimReconciliation(message.FundingClaimReconciliation);

            _logger.LogInformation(PerformanceManagementLoggingId.FinishPersistFundingClaimReconciliation,
                "Finished persisting funding claim reconciliation to CRM. - " +
                $"Period: {period}, Claim Type: {claimTypeName}, Allocation Group Name: {allocationGroupName}, UKPRN: {ukprn}.");

            return Task.CompletedTask;
        }
    }
}