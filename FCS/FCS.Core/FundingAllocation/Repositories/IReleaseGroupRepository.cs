namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dto;
    using Endpoints.CreateFundingAllocationInCrm;
    using LanguageExt;

    public interface IReleaseGroupRepository
    {
        Task<Option<ReleaseGroupId>> GetAwaitingReleaseGroup(string fundingTypeCode, string fundingPeriod, string fspGroupCode,
            string contractType);

        Task<int> CreateReleaseGroup(string fundingTypeCode, string fundingPeriod, string fspGroupCode,
            string contractType, Guid crmReleaseGroupEntityId, string releaseGroupName);

        Task<string> GetNextReleaseGroupName();
    }
}