namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dto;

    public interface IFundingAllocationGroupingService
    {
        public Task<FundingAllocationContractGroup[]> GetFundingAllocationContractGroups(IEnumerable<string> fundingIds);
    }
}
