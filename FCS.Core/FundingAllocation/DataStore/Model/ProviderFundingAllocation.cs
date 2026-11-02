namespace FundingAllocation.DataStore.Model
{
    using Extensions;

    public class ProviderFundingAllocation
    {
        private ProviderFundingAllocation()
        {
        }

        public ProviderFundingAllocation(string providerFundingId, string fundingId)
        {
            ProviderFundingId = providerFundingId;
            FundingId = fundingId;
        }

        public string ProviderFundingId { get; private set; }

        public string FundingId { get; private set; }

        public FundingAllocation FundingAllocation { get; set; }
        public ProviderFunding ProviderFunding { get; set; }

        public string GetProviderFundingName() => ProviderFundingId.RemoveVersionFromId();
        public string GetFundingName() => FundingId.RemoveVersionFromId();
    }
}
