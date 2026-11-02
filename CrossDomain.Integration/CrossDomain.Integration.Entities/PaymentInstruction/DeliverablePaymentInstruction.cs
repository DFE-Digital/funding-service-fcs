namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentInstruction
{
    public class DeliverablePaymentInstruction
    {
        public int DeliverableCode { get; set; }

        public string Period { get; set; }

        public string PeriodTypeCode { get; set; }

        public decimal PaymentValue { get; set; }
    }
}