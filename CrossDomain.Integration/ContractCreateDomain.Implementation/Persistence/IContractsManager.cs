namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    using System.Collections.Generic;
    using Implementation.Entities;
    using ContractRequestSchema = CrossDomain.Integration.Entities.ContractRequest;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractsManager
    {
        string BatchId { get; set; }

        Guid CreateContract(
            CorporateContract.ExtendedContractType contract,
            string correlationId,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null);

        CorporateContract.Contract GetCorporateContract(string contractNumber, string masterContractNumber);

        CorporateContract.Contract GetCorporateContract(string contractNumber, string masterContractNumber, bool lastApproved);

        CorporateContract.Contract GetCorporateContractForSpecificVersion(string contractNumber, string masterContractNumber, int versionNumber);

        SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.Contract GetCorporateContractForSpecificVersion(
            string contractNumber, int version, int subVersion);

        ContractRequestSchema.contractType GetLatestContract(string masterContractNumber, IEnumerable<string> childContractNumbers);

        Guid UpdateContract(CorporateContract.contractType contractToUpdate, string correlationId);

        Guid AmendContract(
            CorporateContract.ExtendedContractType contractToAmend,
            string correlationId,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null);

        Guid UpdateAmendedContract(
            CorporateContract.ExtendedContractType contractToAmend,
            string correlationId,
            Action<ContractIdentity, string, Action> insertAllocationIfNotPresent = null,
            Func<ContractIdentity, Guid> getExistingContractId = null);

        bool CheckContractExists(string correlationId);

        bool DoesContractVersionExist(string contractNumber, int versionNumber);

        IList<CorporateContract.ContractSummary> GetApprovedContracts(DateTime earliestDateTime);

        Guid CreateNewAmendedContract(CorporateContract.ExtendedContractType masterContract, string correlationId);

        int GetMaxWithdrawnContractVersion(string contractNumber);

        int GetMaximumContractVersionNumber(string contractNumber);

        ContractRequestSchema.ContractIdentityInfo GetLastApprovedContractIdentityInfo(string contractNumber);

        Guid GetMostRecentContractId(string contractNumber, int version);

        Guid? GetApprovedContractId(string contractNumber);

        Guid? GetLatestVersionContractId(string contractNumber);

        ContractRequestSchema.contractType GetContractForId(Guid contractId);

        string GetSubStatusOfLastApproved(string contractNumber);
    }
}