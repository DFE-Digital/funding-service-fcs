namespace FundingAllocation.Dto
{
    public class ReleaseGroupNameFundingTypeFundingPeriodInfo
    {
        public ReleaseGroupNameFundingTypeFundingPeriodInfo(string releaseGroupName, 
            string fundingTypeCode, string fundingPeriodCode)
        {
            ReleaseGroupName = releaseGroupName;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
        }

        public string ReleaseGroupName { get; }
        public string FundingTypeCode { get; }
        public string FundingPeriodCode { get; }
    }
}