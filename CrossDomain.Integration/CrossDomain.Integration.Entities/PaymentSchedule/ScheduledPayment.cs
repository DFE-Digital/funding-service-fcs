namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule
{
    using System;

    public class ScheduledPayment
    {
        public string PeriodTypeCode { get; set; }

        public string Period { get; set; }

        public int? PlannedVolume { get; set; }

        public decimal? PlannedValue { get; set; }

        public decimal? ProfilePaymentAmount { get; set; }

        public decimal? CappedPaymentAmount { get; set; }

        public decimal? BalancingPaymentAmount { get; set; }

        public decimal? ReconciliationPaymentAmount { get; set; }

        public decimal NetPaymentAmount { get; set; }

        public int? ActualVolume { get; set; }

        public decimal? ActualValue { get; set; }

        public string CollectionReturnCode { get; set; }

        public int Year => int.Parse(Period.Substring(0, 4));

        public int Month => int.Parse(Period.Substring(4, 2));

        /// <summary>
        /// This is used in CRM
        /// </summary>
        public string PeriodNameDisplayFormat => DateTime.ParseExact(
            Period, "yyyyMM", null).ToString("MMM-yy");
    }
}