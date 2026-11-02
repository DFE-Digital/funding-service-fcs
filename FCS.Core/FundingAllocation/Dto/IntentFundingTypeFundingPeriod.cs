namespace FundingAllocation.Dto
{
    public class IntentFundingTypeFundingPeriod
    {
        public IntentFundingTypeFundingPeriod(bool allowNewAmendment, string precedingFtpFundingPeriod, string precedingFtpFundingType, string ftpGroupCode)
        {
            AllowNewAmendment = allowNewAmendment;
            PrecedingFtpFundingPeriod = precedingFtpFundingPeriod;
            PrecedingFtpFundingType = precedingFtpFundingType;
            FtpGroupCode = ftpGroupCode;
        }

        public bool AllowNewAmendment { get; }
        public string PrecedingFtpFundingPeriod { get; }
        public string PrecedingFtpFundingType { get; }
        public string FtpGroupCode { get; }
    }
}