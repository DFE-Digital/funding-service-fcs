namespace FundingAllocation.Extensions
{
    using System.Linq;
    using Dto;
    using System.Collections.Generic;

    public static class FundingAllocationContractGroupsExtensions
    {
        public static IReadOnlyCollection<FundingTypeFundingPeriod>  
            GetDistinctFundingTypeFundingPeriods(this FundingAllocationContractGroup[] fundingAllocationContractGroups)
        {
            return fundingAllocationContractGroups.Select(facg => 
                    new FundingTypeFundingPeriod(facg.FundingType, facg.FundingPeriod)).Distinct().ToList();
        }
    }
}