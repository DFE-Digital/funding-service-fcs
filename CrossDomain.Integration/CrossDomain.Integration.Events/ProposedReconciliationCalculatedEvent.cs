namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.PerformanceManagement.FundingClaimReconciliation;

    public class ProposedReconciliationCalculatedEvent
    {
        public FundingClaimReconciliation FundingClaimReconciliation { get; set; }
    }
}
