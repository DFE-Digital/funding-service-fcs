namespace PaymentManagement.Calculation.Dtos
{
    public class DeliverablePeriodActualAndPaymentInfo
    {
        public DeliverablePeriodActualAndPaymentInfo(int deliverableCode, int period, int? actualVolume, decimal? actualValue, decimal? profileValue, decimal? cappedPaymentAmount, decimal? balancingPaymentAmount, decimal? reconciliationPaymentAmount, decimal netPaymentAmount, decimal? plannedValue, int? plannedVolume)
        {
            DeliverableCode = deliverableCode;
            Period = period;
            ActualVolume = actualVolume;
            ActualValue = actualValue;
            ProfileValue = profileValue;
            CappedPaymentAmount = cappedPaymentAmount;
            BalancingPaymentAmount = balancingPaymentAmount;
            ReconciliationPaymentAmount = reconciliationPaymentAmount;
            NetPaymentAmount = netPaymentAmount;
            PlannedValue = plannedValue;
            PlannedVolume = plannedVolume;
        }

        public DeliverablePeriodActualAndPaymentInfo(int deliverableCode, int period, int? actualVolume, decimal? actualValue)
        {
            DeliverableCode = deliverableCode;
            Period = period;
            ActualVolume = actualVolume;
            ActualValue = actualValue;
        }

        public int DeliverableCode { get; }

        public int Period { get; }

        public int? ActualVolume { get; }

        public decimal? ActualValue { get; }

        public decimal? ProfileValue { get; }

        public decimal? CappedPaymentAmount { get; }

        public decimal? BalancingPaymentAmount { get; }

        public decimal? ReconciliationPaymentAmount { get; }

        public decimal NetPaymentAmount { get; }

        public decimal? PlannedValue { get; }

        public int? PlannedVolume { get; }

        public DeliverablePeriodPaymentInfo ToPaymentInfo()
        {
            return new DeliverablePeriodPaymentInfo(
                period:Period,
                deliverableCode: DeliverableCode,
                netPaymentAmount: NetPaymentAmount,
                plannedValue: null,
                plannedVolume:PlannedVolume,
                cappedPaymentAmount: CappedPaymentAmount,
                reconciliationPaymentAmount: ReconciliationPaymentAmount,
                actualValue:ActualValue,
                actualVolume:ActualVolume,
                balancingPaymentAmount:BalancingPaymentAmount,
                profilePaymentAmount: ProfileValue);
        }
    }
}
