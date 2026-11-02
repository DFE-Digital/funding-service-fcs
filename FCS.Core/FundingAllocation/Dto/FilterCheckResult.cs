namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    public class FilterCheckResult
    {
        public FilterCheckResult(IReadOnlyCollection<string> fundingIdsForContractControl, IReadOnlyCollection<string> fundingIdsFilteredOut)
        {
            FundingIdsForContractControl = fundingIdsForContractControl;
            FundingIdsFilteredOut = fundingIdsFilteredOut;
        }

        public IReadOnlyCollection<string> FundingIdsForContractControl { get; }
        public IReadOnlyCollection<string> FundingIdsFilteredOut { get; }

        public override string ToString() =>
            $"FundingIdsForContractControl: {FundingIdsForContractControl.Count}, FundingIdsFilteredOut: {FundingIdsFilteredOut.Count}";
    }
}
