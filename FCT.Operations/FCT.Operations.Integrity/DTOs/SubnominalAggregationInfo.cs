namespace SFA.FCT.Operations.Integrity.DTOs
{
    public class SubnominalAggregationInfo
    {
        public string AllocationNumber { get; set; }

        public string Period { get; set; }

        public string SubnominalCode { get; set; }

        public string PaymentType { get; set; }

        public decimal AggregatedValue { get; set; }

        public bool IsInactiveContract { get; set; }
    }
}