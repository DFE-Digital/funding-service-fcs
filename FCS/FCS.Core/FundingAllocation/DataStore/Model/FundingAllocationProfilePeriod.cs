namespace FundingAllocation.DataStore.Model
{
    using System;
    using Extensions;

    public class FundingAllocationProfilePeriod
    {
        private FundingAllocationProfilePeriod()
        {
        }

        public FundingAllocationProfilePeriod(string providerFundingId, string fundingLineCode, int period, decimal plannedValue)
        {
            ProviderFundingId = providerFundingId;
            FundingLineCode = fundingLineCode;
            Period = period;
            PlannedValue = plannedValue;
        }

        public string ProviderFundingId { get; private set; }

        public string FundingLineCode { get; set; }

        /// <summary>
        /// This looks like this 202101
        /// </summary>
        public int Period { get; private set; }

        public decimal PlannedValue { get; private set; }
        
        public FundingAllocationLine FundingAllocationLine { get; private set; }

        public int PeriodMonth => int.Parse(Period.ToString().Substring(4, 2));

        public int PeriodYear => int.Parse(Period.ToString().Substring(0, 4));

        public override bool Equals(object? obj)
        {
            if (obj is FundingAllocationProfilePeriod other)
            {
                return ProviderFundingId.RemoveVersionFromId() == other.ProviderFundingId.RemoveVersionFromId() &&
                       FundingLineCode == other.FundingLineCode &&
                       Period == other.Period &&
                       PlannedValue == other.PlannedValue;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(ProviderFundingId.GetHashCode(), FundingLineCode.GetHashCode(), Period.GetHashCode(), PlannedValue.GetHashCode());
        }
    }
}
