namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Repositories
{
    using System;

    public interface ICrmContractAllocationRepository
    {
        void UpdateStartDate(Guid allocationId, DateTime startDateTime);
    }
}
