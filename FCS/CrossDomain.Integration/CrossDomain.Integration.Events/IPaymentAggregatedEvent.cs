namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporatePaymentAggregation;

    public interface IPaymentAggregatedEvent
    {
        Allocation Allocation { get; set; }

        PaymentEventOrigin PaymentEventOrigin { get; set; }
    }
}
