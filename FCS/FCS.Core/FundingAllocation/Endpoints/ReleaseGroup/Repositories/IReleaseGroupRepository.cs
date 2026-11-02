namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;
    using Dto;
    using LanguageExt;

    public interface IReleaseGroupRepository
    {
        Task<IReadOnlyCollection<string>> GetFundingIds(IEnumerable<string> releaseGroupNames);

        Task<Option<int>> GetReleaseInProgressReleaseGroup(string fundingTypeCode,
            string fundingPeriod, string fspGroupCode, string contractType);
        Task<IReadOnlyCollection<ReleaseGroupInfo>> GetReleaseGroupInfos(IEnumerable<string> releaseGroupNames);

        Task InsertReleaseGroupGroups(
            IReadOnlyCollection<ReleaseGroupGroup> releaseGroupGroups);

        Task<int> GetNextReleaseGroupGroupId();

        Task<ReleaseGroupNameValidationResult> GetReleaseGroupNameValidationResult(
            IReadOnlyCollection<string> releaseGroupNames);
        Task<IReadOnlyCollection<string>> GetCrmEntityIds(IEnumerable<string> releaseGroupNames);

        Task UpdateStatus(IEnumerable<string> releaseGroupNames, ReleaseGroupStatus status);
        Task<IReadOnlyCollection<ReleaseGroupNameFundingTypeFundingPeriodInfo>> 
            GetReleaseGroupNameFundingTypeFundingPeriodInfos(IEnumerable<string> releaseGroupNames);
        Task<IReadOnlyCollection<string>> GetQueuedFundingIds(IEnumerable<string> releaseGroupNames, IReadOnlyCollection<string> relatedContractNumbers);
    }
}