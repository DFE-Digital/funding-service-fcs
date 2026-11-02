namespace Datafix.Tests.Services
{
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagement.DataStore.Services;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common;

    public static class ContractService
    {
        public static SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract GetCorpSchemaContract(ContractIdentifier contractIdentifier)
        {
            ContractsManager contractsManager = new ContractsManager
            {
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            };

            var corporateContract = contractsManager.GetCorporateContractForSpecificVersion(contractIdentifier.ContractNumber,
                contractIdentifier.VersionNumber, contractIdentifier.SubVersionNumber);

            LegalDeliverableService legalDeliverableService = new LegalDeliverableService(new FundingStreamPeriodLegalDeliverableRepository(new ContractManagementDbContext()));
            legalDeliverableService.RemoveNonLegalDeliverablesFromContract(corporateContract);

            SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contract corporateSchema = new ContractTransformer().TransformToCorporateSchemaContract(corporateContract);

            return corporateSchema;
        }
    }
}
