namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class ContractDeliverable
    {
        public ContractDeliverable()
        {
            Deliverable = new Deliverable();
            Amounts = new AmountSummary();
        }

        public Deliverable Deliverable { get; set; }

        public AmountSummary Amounts { get; set; }
    }
}