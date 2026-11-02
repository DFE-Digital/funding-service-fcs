namespace ContractManagement.Cfs.Repositories
{
    using Microsoft.Xrm.Sdk;
    using System;

    public interface IContractRepository
    {
        EntityReference GetChildContractEntityReference(Guid masterContractId);
    }
}