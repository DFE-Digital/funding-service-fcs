namespace SFA.FCT.Operations.Integrity.DTOs
{
    public class CrmDeliverablePaymentData
    {
        /// <summary>
        /// This tells us which deliverable period this belongs to string allocationNumber, int version, string deliverableCode, string period
        /// where period is  DateTime dt = DateTime.ParseExact(period, "yyyyMM", new System.Globalization.CultureInfo("en-GB"));
        // periodDate = dt.ToString("MMM-yy");
        /// </summary>
        public string Key { get; set; }

        public decimal PlannedValue { get; set; }

        public int PlannedVolume { get; set; }

        public decimal ActualValue { get; set; }

        public int ActualVolume { get; set; }

        public decimal? BalancingPaymentValue { get; set; }

        public decimal? CappingPaymentValue { get; set; }

        public decimal? NetPaymentValue { get; set; }

        public decimal? ReconciliationPaymentValue { get; set; }

        public decimal? ProfilePaymentValue { get; set; }

        public bool IsDupilcateRows { get; set; }
    }
}