namespace FundingAllocation.Dto
{
    using System.Collections.Generic;

    public class FundingAllocationIdWithProviderFundingInfos
    {
        public FundingAllocationIdWithProviderFundingInfos(string fundingId, IReadOnlyCollection<ProviderFundingInfo> providerFundingInfos)
        {
            FundingId = fundingId;
            ProviderFundingInfos = providerFundingInfos;
        }

        public string FundingId { get; }

        public IReadOnlyCollection<ProviderFundingInfo> ProviderFundingInfos { get; }
    }
}
