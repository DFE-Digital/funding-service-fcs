namespace SFA.FCT.Operations.Integrity.Helpers
{
    public class DeliverablePaymentData
    {

        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public int DeliverableCode { get; set; }

        public string Period { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int ActualVolume { get; set; }

        public decimal? ReconciliationPaymentValue { get; set; }

        public decimal? CappingPaymentValue { get; set; }

        public decimal NetPaymentValue { get; set; }

        public decimal BalancingPaymentValue { get; set; }

        public decimal ProfilePaymentValue { get; set; }
    }
}
