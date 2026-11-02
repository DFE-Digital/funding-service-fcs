namespace PaymentManagement.Calculation.Dtos
{
    public class CalculationResultLine
    {
        public CalculationResultLine(int period, int deliverableCode, decimal? profileValue, decimal? cappedPaymentAmount, decimal? balancingPaymentAmount, decimal? reconciliationPaymentAmount, decimal netPaymentAmount)
        {
            Period = period;
            DeliverableCode = deliverableCode;
            ProfileValue = profileValue;
            CappedPaymentAmount = cappedPaymentAmount;
            BalancingPaymentAmount = balancingPaymentAmount;
            ReconciliationPaymentAmount = reconciliationPaymentAmount;
            NetPaymentAmount = netPaymentAmount;
        }

        public int Period { get; }

        public int DeliverableCode { get; }

        public decimal? ProfileValue { get; }

        public decimal? CappedPaymentAmount { get; }

        public decimal? BalancingPaymentAmount { get; }

        public decimal? ReconciliationPaymentAmount { get; private set; }

        public decimal NetPaymentAmount { get; private set; }

        public void SetReconciliationPayment(decimal? reconciliationPayment)
        {
            ReconciliationPaymentAmount = reconciliationPayment;
            NetPaymentAmount = (BalancingPaymentAmount ?? 0) + (reconciliationPayment ?? 0);
        }
    }
}
