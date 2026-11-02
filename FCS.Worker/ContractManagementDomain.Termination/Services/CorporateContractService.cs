namespace ContractManagementDomain.Termination.Services
{
    using ContractManagement.DataStore.Services;
    using ContractManagementDomain.Termination.Repositories;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class CorporateContractService : ICorporateContractService
    {
        public contract GetContract(
            ConnectionInfo connectionInfo,
            ICrmContractRepository crmContractRepository,
            IContractsManager contractsManager,
            ILegalDeliverableService legalDeliverableService,
            ContractIdentifier contractIdentifier)
        {
            contract corporateContract = contractsManager.GetCorporateContractForSpecificVersion(
                contractIdentifier);

            legalDeliverableService.RemoveNonLegalDeliverablesFromContract(connectionInfo, corporateContract);

            return corporateContract;
        }
    }
}
