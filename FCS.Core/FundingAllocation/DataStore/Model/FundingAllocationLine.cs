namespace FundingAllocation.DataStore.Model
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;

    public class FundingAllocationLine
    {
        private FundingAllocationLine()
        {
        }

        public FundingAllocationLine(string providerFundingId, string fundingLineCode)
        {
            ProviderFundingId = providerFundingId;
            FundingLineCode = fundingLineCode;
        }

        public string ProviderFundingId { get; private set; }

        public string FundingLineCode { get; private set; }
        public bool IsOfNoInterest { get; set; }

        public ProviderFunding ProviderFunding { get; private set; }

        public List<FundingAllocationProfilePeriod> FundingAllocationProfilePeriods { get; private set; } = new List<FundingAllocationProfilePeriod>();

        public bool HaveAnyPeriodsWithPlannedValue() => FundingAllocationProfilePeriods.Any(p => p.PlannedValue != 0);

        public List<FundingAllocationProfilePeriod> NonZeroFundingAllocationProfilePeriods =>
            FundingAllocationProfilePeriods.Where(p => p.PlannedValue != 0).ToList();

        public string GetProviderFundingName() => ProviderFundingId.RemoveVersionFromId();

        public override bool Equals(object obj)
        {
            if (obj is FundingAllocationLine other)
            {
                return ProviderFundingId == other.ProviderFundingId &&
                       FundingLineCode == other.FundingLineCode;

            }

            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(ProviderFundingId.GetHashCode(), FundingLineCode.GetHashCode());
        }
    }
}
