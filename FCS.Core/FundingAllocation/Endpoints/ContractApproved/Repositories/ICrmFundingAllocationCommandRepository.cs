namespace FundingAllocation.Endpoints.ContractApproved.Repositories
{
    using System;
    using System.Threading.Tasks;

    public interface ICrmFundingAllocationCommandRepository
    {
        Task SetStatusToContractApproved(Guid crmEntityId);
    }
}