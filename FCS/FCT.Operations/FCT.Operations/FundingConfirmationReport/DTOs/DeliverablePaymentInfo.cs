namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    public class DeliverablePaymentInfo
    {
        public DeliverablePaymentInfo(decimal valueA, decimal valueB, string ukprn, string fspCode)
        {
            ValueA = valueA;
            ValueB = valueB;
            Ukprn = ukprn;
            FspCode = fspCode;
        }

        public decimal ValueA { get; }
        public decimal ValueB { get; }
        public string Ukprn { get; }
        public string FspCode { get; }
    }
}
