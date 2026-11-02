namespace FundingAllocation.Services
{
    using System;
    using System.Threading.Tasks;
    using Dto;
    using Endpoints.CreateFundingAllocationInCrm;

    public interface IReleaseGroupService
    {
        Task<ReleaseGroupId> GetOrCreateReleaseGroup(
            string fcsFundingType,
            string fcsPeriod,
            string fspGroupCode,
            string fcsContractType,
            Func<Task<CrmFundingAllocationFks>> getCrmFundingAllocationFKs);
    }
}