namespace FundingAllocation.Dto
{
    public class ReleaseGroupInfo
    {
        public ReleaseGroupInfo(int releaseGroupId, string fundingTypeCode, string fundingPeriodCode)
        {
            ReleaseGroupId = releaseGroupId;
            FundingTypeCode = fundingTypeCode;
            FundingPeriodCode = fundingPeriodCode;
        }

        public int ReleaseGroupId { get; }
        public string FundingTypeCode { get; }
        public string FundingPeriodCode { get; }
    }
}
