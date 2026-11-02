namespace FundingAllocation.Dto
{
    public class FundingIdInfo
    {
        public FundingIdInfo(string fundingId, string fundingIdName, decimal fundingIdVersion)
        {
            FundingId = fundingId;
            FundingIdName = fundingIdName;
            FundingIdVersion = fundingIdVersion;
        }

        public string FundingId { get; }

        public string FundingIdName { get; }

        public decimal FundingIdVersion { get; }
    }
}