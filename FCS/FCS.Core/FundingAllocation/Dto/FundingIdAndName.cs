namespace FundingAllocation.Dto
{
    public class FundingIdAndName
    {
        public FundingIdAndName(string fundingId, string fundingAllocationName)
        {
            FundingId = fundingId;
            FundingAllocationName = fundingAllocationName;
        }

        public string FundingId { get; }
        public string FundingAllocationName { get; }
    }
}
