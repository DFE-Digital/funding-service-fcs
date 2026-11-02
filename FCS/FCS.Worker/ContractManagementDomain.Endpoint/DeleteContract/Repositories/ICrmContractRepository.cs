namespace ContractManagementDomain.Endpoint.DeleteContract.Repositories
{
    using System;
    using System.Collections.Generic;

    public interface ICrmContractRepository
    {
        IReadOnlyCollection<CrmContractIdentity> GetContractIds(string contractNumber, int versionNumber);

        void DeleteContractsTasksAndWorkflows(IReadOnlyCollection<Guid> contractIds);

        bool AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(Guid masterContractId, IReadOnlyCollection<Guid> childContracts);

        Guid? GetLastApprovedContractId(string contractNumber);

        void UpdateContractToLatestVersion(Guid contractId);

        bool IsSingleContractWhichIsNotSupersededDraft(string contractNumber, int versionNumber);
    }
}