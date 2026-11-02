namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;

    public interface IReleaseGroupFundingAllocationRepository
    {
        Task<FundingAllocation> GetFundingAllocationForId(string fundingId);

        Task<FundingAllocation[]> GetFundingAllocationsWithOfInterestLinesForIds(IEnumerable<string> fundingIds);

        Task UpdateFundingAllocationsWithContractId(IEnumerable<string> fundingIds, int contractId);

        Task<FundingAllocationGroupingInfo[]> GetFundingAllocationGroupingInfos(IEnumerable<string> fundingIds);

        Task RemoveQueuedInfoFromQueuedFundingAllocations(IReadOnlyCollection<string> queuedFundingIds,
            IEnumerable<string> contractNumbers);

        Task<IReadOnlyCollection<string>> GetMatchingLastApprovedFundingIds(IReadOnlyCollection<string> fundingNames);
        Task<IReadOnlyCollection<int>> GetReleaseGroupIds(IEnumerable<string> fundingIds);
        Task RemoveAnyOrphanedQueuedContracts();

        Task<IReadOnlyCollection<Guid>> GetFundingAllocationCrmIds(IEnumerable<string> fundingIds);
    }
}