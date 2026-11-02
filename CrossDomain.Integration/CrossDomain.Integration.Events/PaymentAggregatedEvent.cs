namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporatePaymentAggregation;

    public class PaymentAggregatedEvent : IPaymentAggregatedEvent
    {
        public Allocation Allocation { get; set; }

        public PaymentEventOrigin PaymentEventOrigin { get; set; }

        public int TimesMessageDeferred { get; set; }
    }
}
