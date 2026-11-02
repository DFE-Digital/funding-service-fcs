namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure.Repositories
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public interface ICrmContractRepository
    {
        bool IsContractClosed(string contractNumber);

        Guid GetContractId(string contractNumber, int version, int subVersion);

        IReadOnlyCollection<Guid> GetAllocationIdsForContract(string contractNumber, int version, int subVersion);

        void UpdateContract(sfa_contract contract);
    }
}
