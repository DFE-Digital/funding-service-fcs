namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporatePaymentAggregation;

    public class AllocationPaymentsChangedOnAggregationEvent : IAllocationPaymentsChangedEvent
    {
        public Allocation Allocation { get; set; }

        public PaymentEventOrigin PaymentEventOrigin { get; set; }

        public int TimesMessageDeferred { get; set; }

        public string AllocationNumber { get; set; }

        public bool HasOutstandingPayments { get; set; }

        public override string ToString()
        {
            return $"AllocationNumber: {AllocationNumber}, Version: {Allocation.VersionNumber}, PaymentEventOrigin: {PaymentEventOrigin}";
        }
    }
}