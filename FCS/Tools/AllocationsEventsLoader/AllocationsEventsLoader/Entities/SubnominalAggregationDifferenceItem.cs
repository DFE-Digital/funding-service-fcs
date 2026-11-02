namespace AllocationsEventsLoader.Entities
{
    public class SubnominalAggregationDifferenceItem
    {
        public string AllocationNumber { get; set; }

        public string Period { get; set; }

        public string SubnominalCode { get; set; }

        public string PaymentType { get; set; }

        public decimal? SqlAggregatedValue { get; set; }

        public decimal? CrmAggregatedValue { get; set; }

        public string ComparisonDirection { get; set; }
    }
}
