namespace FundingAllocation.Tests.TestHelpers
{
    using DataStore.Model;

    public static class ProviderFundingAllocationHelper
    {
        public static ProviderFundingAllocation EmptyProviderFundingAllocation =>
            new ProviderFundingAllocation("", "")
            {
                ProviderFunding = new ProviderFunding(string.Empty, default, "", "")
            };

        public static ProviderFundingAllocation WithProviderFundingId(
            this ProviderFundingAllocation providerFundingAllocation, string providerFundingId)
        {
            return new ProviderFundingAllocation(
                    providerFundingId,
                    providerFundingAllocation.FundingId)
                {
                    ProviderFunding = new ProviderFunding(providerFundingId, providerFundingAllocation.ProviderFunding.DeliveryUkprn,
                        providerFundingAllocation.ProviderFunding.ProviderType,
                        providerFundingAllocation.ProviderFunding.ProviderSubType)
                }
                .WithPropertiesFrom(providerFundingAllocation);
        }

        public static ProviderFundingAllocation WithFundingId(
            this ProviderFundingAllocation providerFundingAllocation, string fundingId)
        {
            return new ProviderFundingAllocation(
                    providerFundingAllocation.ProviderFundingId,
                    fundingId)
                {
                    ProviderFunding = new ProviderFunding(
                        providerFundingAllocation.ProviderFundingId,
                        providerFundingAllocation.ProviderFunding.DeliveryUkprn,
                        providerFundingAllocation.ProviderFunding.ProviderType,
                        providerFundingAllocation.ProviderFunding.ProviderSubType)
                }
                .WithPropertiesFrom(providerFundingAllocation);
        }

        private static ProviderFundingAllocation WithPropertiesFrom(this ProviderFundingAllocation target,
            ProviderFundingAllocation source)
        {
            target.ProviderFunding.FundingAllocationLines.AddRange(source.ProviderFunding.FundingAllocationLines);
            return target;
        }
    }
}
