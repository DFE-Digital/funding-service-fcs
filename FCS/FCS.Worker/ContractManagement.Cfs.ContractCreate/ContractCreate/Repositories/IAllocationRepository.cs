namespace ContractManagement.Cfs.ContractCreate.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;

    public interface IAllocationRepository
    {
        void ReleaseAllocation(Guid allocationId, EntityReference contractEntityReference);
    }
}