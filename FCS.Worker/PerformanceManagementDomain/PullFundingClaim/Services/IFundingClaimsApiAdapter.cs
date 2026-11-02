namespace PerformanceManagementDomain.PullFundingClaim.Services
{
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DTOs;

    public interface IFundingClaimsApiAdapter
    {
        Task<IReadOnlyCollection<string>> GetFundingClaimCompletedCollections(DateTime sinceDateTime);

        Task<int> GetCountOfFundingClaimsForCollectionKey(string dataCollectionKey);

        Task<IReadOnlyCollection<FundingClaimApiDto>> GetFundingClaimsForCollectionKey(string dataCollectionKey,
            int pageNumber);

        int PageSize { get; }
    }
}