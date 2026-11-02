namespace ContractCreateDomain.Endpoint.XrmService.Services
{
    using System;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;

    public interface IContractDeDuplicationService
    {
        bool IsAllocationPresent(ContractIdentity contractIdentity, string allocationNumber);

        Guid GetExistingContractId(ContractIdentity contractIdentity);

        void InsertAllocationWithoutDuplication(ContractIdentity contractIdentity, string allocationNumber,
            Action insert);
    }
}