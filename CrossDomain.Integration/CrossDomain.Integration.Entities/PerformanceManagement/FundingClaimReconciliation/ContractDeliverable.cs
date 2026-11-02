namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
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