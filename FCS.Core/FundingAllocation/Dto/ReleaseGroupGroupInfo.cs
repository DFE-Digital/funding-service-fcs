namespace FundingAllocation.Dto
{
    public class ReleaseGroupGroupInfo
    {
        public ReleaseGroupGroupInfo(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodCode)
        {
            ReleaseGroupGroupId = releaseGroupGroupId;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
        }

        public int ReleaseGroupGroupId { get; }
        public string FundingTypeCode { get; }
        public string FundingPeriodCode { get; }
    }
}
