namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    public class FspAllocationAndFunded
    {
        public FspAllocationAndFunded(string fspCode, string desc, decimal allocationValue, decimal fundedValue, int order, PaymentMethod paymentMethod)
        {
            FspCode = fspCode;
            Desc = desc;
            AllocationValue = allocationValue;
            FundedValue = fundedValue;
            Order = order;
            PaymentMethod = paymentMethod;
        }

        public string FspCode { get; }
        public string Desc { get; }
        public decimal AllocationValue { get; }
        public decimal FundedValue { get; }
        public int Order { get; }
        public PaymentMethod PaymentMethod { get; }
    }
}