namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using Dto;
    using System.Threading.Tasks;

    public interface IReleaseGroupRepository
    {
        Task<bool> SetToReleasedIfNotAlready(string releaseGroupName);
        Task<string> GetCrmEntityId(string releaseGroupName);
        Task<FundingTypeFundingPeriod> GetFundingTypeFundingPeriod(string releaseGroupName);
        Task<bool> IsReleaseGroupGroupReleased(string releaseGroupName);
        Task<int> GetReleaseGroupGroupId(string releaseGroupName);
    }
}