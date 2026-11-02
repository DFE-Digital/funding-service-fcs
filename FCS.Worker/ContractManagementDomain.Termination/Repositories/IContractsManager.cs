namespace ContractManagementDomain.Termination.Repositories
{
    using SFA.FCT.ContractManagementService.Common;

    public interface IContractsManager
    {
        SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract GetCorporateContract(string contractNumber,
            string masterContractNumber, bool lastApproved);

        SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contract GetCorporateContractForSpecificVersion(
            ContractIdentifier contractIdentifier);
    }
}
