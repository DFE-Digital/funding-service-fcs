namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.AggregatePaymentEndpoint.DTOs
{
    public class SimpleSubnominalAggregation
    {
        public SimpleSubnominalAggregation(string allocationNumber, string period, string subnominalCode, string paymentType, bool isPosted)
        {
            AllocationNumber = allocationNumber;
            Period = period;
            SubnominalCode = subnominalCode;
            PaymentType = paymentType;
            IsPosted = isPosted;
        }

        public string AllocationNumber { get; }
        public string Period { get; }
        public string SubnominalCode { get; }
        public string PaymentType { get; }

        public bool IsPosted { get; }

        public decimal AggregatedValue { get; set; }

        public int VersionNumber { get; set; }
    }
}
