namespace PaymentManagement.Calculation.Dtos
{
    public class DeliverablePeriodPaymentInfo
    {
        public DeliverablePeriodPaymentInfo(int period, int deliverableCode, decimal netPaymentAmount, decimal? plannedValue, int? plannedVolume, 
            decimal? cappedPaymentAmount, decimal? reconciliationPaymentAmount, int? actualVolume, decimal? actualValue, decimal? balancingPaymentAmount = null, decimal? profilePaymentAmount = null)
        {
            Period = period;
            DeliverableCode = deliverableCode;
            NetPaymentAmount = netPaymentAmount;
            PlannedValue = plannedValue;
            PlannedVolume = plannedVolume;
            CappedPaymentAmount = cappedPaymentAmount;
            ReconciliationPaymentAmount = reconciliationPaymentAmount;
            ActualVolume = actualVolume;
            ActualValue = actualValue;
            BalancingPaymentAmount = balancingPaymentAmount;
            ProfilePaymentAmount = profilePaymentAmount;
        }

        /// <summary>
        /// this looks like this 202010
        /// </summary>
        public int Period { get; }

        public int DeliverableCode { get; }

        public decimal NetPaymentAmount { get; }

        public decimal? PlannedValue { get; set; }

        public int? PlannedVolume { get; }

        public decimal? CappedPaymentAmount { get; }

        public decimal? ReconciliationPaymentAmount { get; }

        public int? ActualVolume { get; }

        public decimal? ActualValue { get; }

        public bool HasPlannedValueOrVolume => PlannedValue.HasValue || PlannedVolume.HasValue;

        public decimal? BalancingPaymentAmount { get; }

        public decimal? ProfilePaymentAmount { get; }
    }
}
