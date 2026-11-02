namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO.Levy
{
    public class ContractDeliverablePeriodInfo
    {
        public int DeliverableCode { get; set; }

        public string DeliverableDescription { get; set; }
        
        public int? ParentDeliverableCode { get; set; }

        public decimal? DeliverablePlannedValue { get; set; }

        public int? Month { get; set; }

        public int? Year { get; set; }

        public decimal? PlannedValue { get; set; }

        public string FundingStreamCode { get; set; }

        public string AllocationNumber { get; set; }
        public decimal? NetPaymentAmount { get; set; }
        public decimal? ReconciliationAmount { get; set; }
        public decimal? BalancingAmount { get; set; }

        public decimal? CappingAmount { get; set; }

        public override bool Equals(object obj)
        {
            if (obj is ContractDeliverablePeriodInfo other)
            {
                return this.DeliverableCode == other.DeliverableCode &&
                       this.DeliverablePlannedValue == other.DeliverablePlannedValue &&
                       this.FundingStreamCode == other.FundingStreamCode;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return this.DeliverableCode.GetHashCode() ^ this.FundingStreamCode.GetHashCode();
        }

        public override string ToString()
        {
            return $"FundingStreamCode: {FundingStreamCode}, DeliverableCode: {DeliverableCode}";
        }
    }
}
