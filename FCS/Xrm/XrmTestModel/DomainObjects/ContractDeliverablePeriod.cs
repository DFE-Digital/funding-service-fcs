namespace XrmTestModel
{
    public class ContractDeliverablePeriod
    {
        public virtual ContractDeliverable Deliverable { get; set; }

        public int PeriodNumber { get; set; }

        public int Year { get; set; }

        public string PeriodName { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int ActualVolume { get; set; }

        public bool Aggregate { get; set; }

        public bool PaymentPosted { get; set; }

        public decimal? ReconcilationPayment { get; set; }

        public virtual SubnominalAggregation ProfileSubnominal { get; set; }

        public virtual SubnominalAggregation CappingSubnominal { get; set; }

        public virtual SubnominalAggregation ReconcilationSubnominal { get; set; }
    }
}
