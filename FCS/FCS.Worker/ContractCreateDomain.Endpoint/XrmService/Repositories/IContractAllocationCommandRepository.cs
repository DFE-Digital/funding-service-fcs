namespace ContractCreateDomain.Endpoint.XrmService.Repositories
{
    using System;

    public interface IContractAllocationCommandRepository
    {
        void DeleteAllocation(Guid allocationId);
    }
}