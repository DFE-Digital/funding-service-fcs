namespace FCT.Operations.FundingConfirmationReport.DTOs
{
    public enum PaymentMethod
    {
        NoPay = 0,
        PayOnActuals = 1,
        PayOnProfile = 2,
        PayOnInstruction = 3,
        NoCalcAndNoPay = 4
    }

    public class FspInfo
    {
        public FspInfo(string fspCode, string description, PaymentMethod paymentMethod, string periodTypeCode, int order)
        {
            FspCode = fspCode;
            Description = description;
            PaymentMethod = paymentMethod;
            PeriodTypeCode = periodTypeCode;
            Order = order;
        }

        public string FspCode { get; }
        public string Description { get; }
        public PaymentMethod PaymentMethod { get; }
        public string PeriodTypeCode { get; }
        public int Order { get; }
        public bool IsAcademicYear => PeriodTypeCode.Substring(0, 2) == "AY";
        public bool IsProcuredFSP => PeriodTypeCode == "NONLEVY";
    }
}
