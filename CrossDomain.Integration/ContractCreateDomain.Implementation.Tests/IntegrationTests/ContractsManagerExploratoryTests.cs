namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Diagnostics;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using UnitTests.Common;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractsManagerExploratoryTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("PerformanceTest")]
        public void ShouldCreateContractsInCrmThenRemove()
        {
            const string batchId = "XX";
            const string correlationId = "ZZZ";
            CorporateContract.ExtendedContract masterContract = GetExtendedCorpContract();

            const int numMasterContractsToCreate = 10;
            DateTime beginningTime = DateTime.Now;
            Guid masterContractGuid = new Guid();
            for (int i = 0; i < numMasterContractsToCreate; i++)
            {
                try
                {
                    var contractsManager = Container.Resolve<IContractsManager>();
                    contractsManager.BatchId = batchId;
                    masterContractGuid = contractsManager.CreateContract(masterContract, correlationId);
                    Assert.IsTrue(masterContractGuid != null);
                }
                finally
                {
                    // now remove the contracts and then the master
                    RemoveMasterAndChildContracts(masterContractGuid);
                }
            }

            TimeSpan duration = DateTime.Now - beginningTime;

            Debug.WriteLine($"Time for loading {numMasterContractsToCreate} contract is {duration.TotalSeconds} seconds");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldCreateContractsAndOrgWithUpin()
        {
            const string correlationId = "ZZZ";
            CreateContractCommand command = TestResource.FromJson<CreateContractCommand>(
                "ContractCreateDomain.Implementation.Tests.Resources", "CreateContractCommand.json");

            var contractsManager = CreateContractsManager();

            contractsManager.CreateContract(command.CorporateContract, correlationId);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ShouldCreateContractsAndDeliveryOrg()
        {
            const string correlationId = "ZZZ";
            CreateContractCommand command = TestResource.FromJson<CreateContractCommand>(
                "ContractCreateDomain.Implementation.Tests.Resources", "ContractWithDeliveryOrg.json");

            var contractsManager = Container.Resolve<IContractsManager>();

            contractsManager.CreateContract(command.CorporateContract, correlationId);
        }

        private static IContractsManager CreateContractsManager()
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            return new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = organizationService
                },
                OrganizationService = organizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = organizationService
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = organizationService
                }
            };
        }

        private ILookupManager GetLookupManager()
        {
            return new LookupManager
            {
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager(),
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService()
            };
        }
    }
}
