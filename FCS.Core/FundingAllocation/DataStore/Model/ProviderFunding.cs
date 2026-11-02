namespace FundingAllocation.DataStore.Model
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;

    public class ProviderFunding
    {
        private ProviderFunding()
        {
        }

        public ProviderFunding(string providerFundingId, int deliveryUkprn, string providerType, string providerSubType)
        {
            ProviderFundingId = providerFundingId;
            DeliveryUkprn = deliveryUkprn;
            ProviderType = providerType;
            ProviderSubType = providerSubType;
        }

        public string ProviderFundingId { get; private set; }
        public int DeliveryUkprn { get; private set; }
        public string ProviderType { get; private set; }
        public string ProviderSubType { get; private set; }
        public List<ProviderFundingAllocation> ProviderFundingAllocations { get; private set; } = new List<ProviderFundingAllocation>();

        public List<FundingAllocationLine> FundingAllocationLines { get; set; } = new List<FundingAllocationLine>();

        public bool HasOneOrMoreFundingLinesWithOneOrMoreNonZeroPeriods()
        {
            return FundingAllocationLines.Any(l => l.HaveAnyPeriodsWithPlannedValue());
        }

        public string GetProviderFundingName() => ProviderFundingId.RemoveVersionFromId();
    }
}
