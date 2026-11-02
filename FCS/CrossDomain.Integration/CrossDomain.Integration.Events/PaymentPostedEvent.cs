namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporatePaymentAggregation;

    public class PaymentPostedEvent : IPaymentPostedEvent, IAllocationPaymentsChangedOnPostingEvent
    {
        public Allocation Allocation { get; set; }

        public string AllocationNumber { get; set; }

        public bool HasOutstandingPayments { get; set; }
    }
}
