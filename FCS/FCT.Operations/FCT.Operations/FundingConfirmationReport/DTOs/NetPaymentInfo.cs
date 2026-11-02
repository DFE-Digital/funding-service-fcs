namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    public class NetPaymentInfo
    {
        public NetPaymentInfo(decimal netPayment, string ukprn, string fspCode)
        {
            NetPayment = netPayment;
            Ukprn = ukprn;
            FspCode = fspCode;
        }

        public decimal NetPayment { get; }
        public string Ukprn { get; }
        public string FspCode { get; }
    }
}
