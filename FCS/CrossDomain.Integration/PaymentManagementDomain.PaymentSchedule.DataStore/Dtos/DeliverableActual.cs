namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos
{
    public class DeliverableActual
    {
        public DeliverableActual(int deliverableCode, decimal? value, int? volume)
        {
            Value = value;
            Volume = volume;
            DeliverableCode = deliverableCode;
        }

        public DeliverableActual(int deliverableCode, decimal? value, int? volume, int? parentDeliverableCode) : this(deliverableCode, value, volume)
        {
            ParentDeliverableCode = parentDeliverableCode;
        }

        public decimal? Value { get; set; }

        public int? Volume { get; set; }

        public int DeliverableCode { get; }

        public int? ParentDeliverableCode { get; }
    }
}
