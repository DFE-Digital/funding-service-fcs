namespace SFA.FCT.Operations.Integrity.DTOs
{
    using System;
    using Utils;

    public class DeliverablePaymentWithFsp
    {
        public string FundingStreamPeriodCode { get; set; }

        public string AllocationNumber { get; set; }

        public int DeliverableCode { get; set; }

        public string Period { get; set; }

        public string Year { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int ActualVolume { get; set; }

        public decimal ProfilePaymentAmount { get; set; }

        public decimal BalancingPaymentAmount { get; set; }

        public decimal ReconciliationPaymentAmount { get; set; }

        public decimal CappedPaymentAmount { get; set; }

        public decimal NetPaymentAmount { get; set; }

        public int VersionNumber { get; set; }

        public DateTime ExecutionTimeUtc { get; set; }

        [IgnoreColumnWhenGeneratingCsv]
        public int PaymentMethod { get; set; }

        [IgnoreColumnWhenGeneratingCsv]
        public string YearPeriod => Year + Period;
    }
}
