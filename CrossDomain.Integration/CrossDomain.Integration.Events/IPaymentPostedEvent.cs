namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporatePaymentAggregation;

    public interface IPaymentPostedEvent
    {
        Allocation Allocation { get; set; }
    }
}
