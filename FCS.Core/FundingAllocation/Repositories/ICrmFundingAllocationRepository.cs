namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Endpoints.CreateFundingAllocationInCrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public interface ICrmFundingAllocationRepository
    {
        Task<Guid> AddFundingAllocation(FundingAllocationDto fundingAllocation, CrmFundingAllocationFks fundingAllocationFks);
        Task<CrmFundingAllocationFks> GetForeignKeys(FundingAllocationDto fundingAllocation);

        Task Update(string crmFundingAllocationEntityId, string releaseGroupId, sfa_FundingAllocationServiceResponse serviceResponse);

        Task SetToQueued(string crmFundingAllocationEntityId, string contractNumber, DateTime queuedOn);

        Task ClearQueued(string crmFundingAllocationEntityId);
    }
}