namespace ContractManagementDomain.Endpoint.Tests.Integration.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using Castle.Windsor;
    using Castle.MicroKernel.Lifestyle;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using Endpoint.DeleteContract;
    using Endpoint.DeleteContract.Repositories;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractIds_ShouldReturnIdsForAContractWithSubversions()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid parentContract = CreateTestContract(masterContractNumber);
            EntityReference parent = new EntityReference(sfa_contract.EntityLogicalName, parentContract);
            CreateTestContract(contractNumber, versionNumber, 2, parent);
            CreateTestContract(contractNumber, versionNumber, 3, parent);
            CreateTestContract(contractNumber, versionNumber, 4, parent);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            IReadOnlyCollection<CrmContractIdentity> contractIds = crmContractRepository.GetContractIds(contractNumber, versionNumber);

            // assert
            Assert.AreEqual(3, contractIds.Count, "Incorrect number of contract ids returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractIds_ShouldOneIdForaContractWithNoSubversions()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            CreateTestContract(contractNumber, versionNumber, 1);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            IReadOnlyCollection<CrmContractIdentity> contractIds = crmContractRepository.GetContractIds(contractNumber, versionNumber);

            // assert
            Assert.AreEqual(1, contractIds.Count, "Incorrect number of contract ids returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractIds_ShouldNotReturnIdsWhenTheContractDoesNotExist()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            IReadOnlyCollection<CrmContractIdentity> contractIds = crmContractRepository.GetContractIds(contractNumber, versionNumber);

            // assert
            Assert.AreEqual(0, contractIds.Count, "Incorrect number of contract ids returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_DeleteContract_ShouldDeleteContractWhenTheContractHasSubversions()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid parentContract = CreateTestContract(masterContractNumber, versionNumber, 1);
            EntityReference parent = new EntityReference(sfa_contract.EntityLogicalName, parentContract);
            CreateTestContract(contractNumber, versionNumber, 2, parent);
            CreateTestContract(contractNumber, versionNumber, 3, parent);
            CreateTestContract(contractNumber, versionNumber, 4, parent);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            IReadOnlyCollection<CrmContractIdentity> contractIds = crmContractRepository.GetContractIds(contractNumber, versionNumber);
            var allContractIds = contractIds.Select(ci => ci.ContractId).ToList();
            var masterContractIds = contractIds.Select(ci => ci.MasterContractId).Distinct().ToList();

            allContractIds.AddRange(masterContractIds);
            // act

            crmContractRepository.DeleteContractsTasksAndWorkflows(allContractIds);

            // assert
            int numberOfChildContracts = GetCountOfContracts(contractNumber, versionNumber);
            int numberOfMasterContracts = GetCountOfContracts(masterContractNumber, versionNumber);

            Assert.AreEqual(0, numberOfChildContracts, "Incorrect number of contracts deleted");
            Assert.AreEqual(0, numberOfMasterContracts, "Incorrect number of master contracts deleted");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_DeleteContract_ShouldDeleteAContractWhenThereAreTasksAssociated()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, 1);

            AddTaskToContract(contractNumber, versionNumber);
            AddTaskToContract(contractNumber, versionNumber);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            crmContractRepository.DeleteContractsTasksAndWorkflows(new List<Guid> { contractId });

            // assert
            int numberOfTasks = GetCountOfTasks(contractNumber, versionNumber);
            Assert.IsTrue(numberOfTasks == 0, "Contract tasks were not deleted");

            int numberOfContracts = GetCountOfContracts(contractNumber, versionNumber);
            Assert.IsTrue(numberOfContracts == 0, "Contract not deleted");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_DeleteContract_ShouldDeleteAContractWhenThereAreWorkFlowsAssociated()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, 1);

            AddWorkflowToContract(contractNumber, versionNumber);
            AddWorkflowToContract(contractNumber, versionNumber);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            crmContractRepository.DeleteContractsTasksAndWorkflows(new List<Guid> { contractId });

            // assert
            int numberOfWorkflows = GetCountOfWorkflows(contractNumber, versionNumber);
            Assert.IsTrue(numberOfWorkflows == 0, "Contract workflows were not deleted");

            int numberOfContracts = GetCountOfContracts(contractNumber, versionNumber);
            Assert.IsTrue(numberOfContracts == 0, "Contract not deleted");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_DeleteContract_ShouldDeleteAContractWhenThereAreWorkFlowsAndTasksAssociated()
        {
            // arrange 
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, 1);

            AddWorkflowToContract(contractNumber, versionNumber);
            AddWorkflowToContract(contractNumber, versionNumber);
            AddTaskToContract(contractNumber, versionNumber);
            AddTaskToContract(contractNumber, versionNumber);

            ICrmContractRepository crmContractRepository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            crmContractRepository.DeleteContractsTasksAndWorkflows(new List<Guid> { contractId });

            // assert
            int numberOfWorkflows = GetCountOfWorkflows(contractNumber, versionNumber);
            Assert.IsTrue(numberOfWorkflows == 0, "Contract workflows were not deleted");

            int numberOfTasks = GetCountOfTasks(contractNumber, versionNumber);
            Assert.IsTrue(numberOfTasks == 0, "Contract tasks were not deleted");

            int numberOfContracts = GetCountOfContracts(contractNumber, versionNumber);
            Assert.IsTrue(numberOfContracts == 0, "Contract not deleted");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_AreTheseChildContractsTheOnlyOnesRelatedToTheMaster_WhenMasterHasOtherVersionOfTheSameChildContract_ShouldReturnTrue()
        {
            // arrange
            const string contractNumber = "XX=Test-Child";
            const string masterContractNumber = "XX=Test-Master";

            DeleteContracts(contractNumber);
            DeleteContracts(masterContractNumber);

            ICrmContractRepository crmContractRepositoryUnderTest = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            Guid parentContractGuid = CreateTestContract(masterContractNumber);
            EntityReference parentEntityReference = new EntityReference(sfa_contract.EntityLogicalName, parentContractGuid);

            List<Guid> childContracts = new List<Guid>();
            childContracts.Add(CreateTestContract(contractNumber, 1, 0, parentEntityReference));
            childContracts.Add(CreateTestContract(contractNumber, 2, 0, parentEntityReference));

            // act
            bool areTheseTheOnlyOnes = crmContractRepositoryUnderTest.AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(parentContractGuid, childContracts);

            // assert
            Assert.IsTrue(areTheseTheOnlyOnes);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_AreTheseChildContractsTheOnlyOnesRelatedToTheMaster_WhenMasterHasOtherChildContract_ShouldReturnFalse()
        {
            // arrange
            const string contractNumberMain1617 = "XX=Test-Main-1617";
            const string contractNumberMain1718 = "XX=Test-Main-1718";
            const string masterContractNumber = "XX=Test-Master-Multi";

            DeleteContracts(contractNumberMain1617);
            DeleteContracts(contractNumberMain1718);
            DeleteContracts(masterContractNumber);

            ICrmContractRepository crmContractRepositoryUnderTest = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            Guid parentContractGuid = CreateTestContract(masterContractNumber);
            EntityReference parentEntityReference = new EntityReference(sfa_contract.EntityLogicalName, parentContractGuid);

            List<Guid> childContracts = new List<Guid>();
            childContracts.Add(CreateTestContract(contractNumberMain1617, 1, 0, parentEntityReference));
            CreateTestContract(contractNumberMain1718, 1, 0, parentEntityReference);

            // act
            bool areTheseTheOnlyOnes = crmContractRepositoryUnderTest.AreTheseChildContractsTheOnlyOnesRelatedToTheMaster(parentContractGuid, childContracts);

            // assert
            Assert.IsFalse(areTheseTheOnlyOnes);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldReturnLastApprovedContractId_WhenThereIsOne()
        {
            // arrange
            const string contractNumber = "XX-Test";
            const int oneSecond = 1000;
            int versionNumber = 1;

            DeleteContracts(contractNumber);
            CreateTestContractWithStatus(contractNumber, versionNumber++, sfa_contractstatus.Draft);
            System.Threading.Tasks.Task.Delay(TimeSpan.FromMilliseconds(oneSecond)).Wait();

            Guid contractId = CreateTestContractWithStatus(contractNumber, versionNumber++, sfa_contractstatus.Approved);
            CreateTestContractWithStatus(contractNumber, versionNumber, sfa_contractstatus.Draft);

            ICrmContractRepository crmContractRepositoryUnderTest = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            Guid? lastApprovedContractId = crmContractRepositoryUnderTest.GetLastApprovedContractId(contractNumber);

            // assert
            Assert.AreEqual(contractId, lastApprovedContractId.Value, "We have not returned the right contract");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldReturnLastApprovedContractIdAsNull_WhenThereIsntOne()
        {
            // arrange
            const string contractNumber = "XX-Test";

            DeleteContracts(contractNumber);

            ICrmContractRepository crmContractRepositoryUnderTest = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            Guid? lastApprovedContractId = crmContractRepositoryUnderTest.GetLastApprovedContractId(contractNumber);

            // assert
            Assert.IsNull(lastApprovedContractId, "We have not returned null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldUpdateContractToLatestVersion()
        {
            // arrange
            const string contractNumber = "XX=Test-version";
            int versionNumber = 1;

            DeleteContracts(contractNumber);
            Guid contractId = CreateTestContract(contractNumber, versionNumber, 1);
            Guid secondContract = CreateTestContract(contractNumber, versionNumber, 2);
            UpdateContractLatestToFalse(contractId);
            Assert.IsFalse(IsLatestVersion(contractId), "The first contract should not be the latest");
            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            repository.UpdateContractToLatestVersion(contractId);

            // assert
            Assert.IsTrue(IsLatestVersion(contractId), "The most recent non withdrawn contract is not the latest");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsSingleContractWhichIsNotSupersededDraft_ShouldReturnTrueWhenThereIsOneContractWithStatusOfDraft()
        {
            // test for normal no duplicate contracts scenario
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;

            // arrange
            RemoveContract(contractNumberToTest, versionToTest);

            CreateContractWithSubversionAndStatus(
                contractNumberToTest: contractNumberToTest,
                version: versionToTest,
                subVersion: 0,
                contractStatus: sfa_contractstatus.Draft);

            ICrmContractRepository repository = GetContainer().Resolve<ICrmContractRepository>();

            // act
            var response = repository.IsSingleContractWhichIsNotSupersededDraft(contractNumberToTest, versionToTest);

            // assert
            Assert.IsTrue(response, "Incorrectly returned false when there are no duplicate contracts");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_IsSingleContractWhichIsNotSupersededDraft_ShouldReturnTrueWhenThereAreTwoDuplicateContractsButOneHasStatusOfSupersededDraft()
        {
            //1. The following instances exist for a given contract:
            //    Version Subversion      Status 

            //    1          0            Superseded

            //    1          1            Draft

            //  ==> Delete should be allowed

            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 1;

            // arrange
            RemoveContract(contractNumberToTest, versionToTest);

            CreateContractWithSubversionAndStatus(
                contractNumberToTest: contractNumberToTest,
                version: versionToTest,
                subVersion: 0,
                contractStatus: sfa_contractstatus.SupersededDraft);

            CreateContractWithSubversionAndStatus(
                contractNumberToTest: contractNumberToTest,
                version: versionToTest,
                subVersion: 1,
                contractStatus: sfa_contractstatus.Draft);

            ICrmContractRepository repository = GetContainer().Resolve<ICrmContractRepository>();

            // act
            var response = repository.IsSingleContractWhichIsNotSupersededDraft(contractNumberToTest, versionToTest);

            // assert
            Assert.IsTrue(response, "Incorrectly returned false when one of the two duplicate contracts has a valid contract status of 'SupersededDraft'");
        }

        private void UpdateContractLatestToFalse(Guid contractId)
        {
            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_LatestVersion = false
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(contract);
        }

        private bool IsLatestVersion(Guid contractId)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_contractSet.First(c => c.sfa_contractId == contractId).sfa_LatestVersion.Value;
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                List<CrmContractIdentity> contractIds = crmContext.sfa_contractSet
                .Where(c => c.sfa_number == contractNumber)
                .Select(c => new CrmContractIdentity
                {
                    ContractId = c.sfa_contractId.Value,
                    MasterContractId = c.sfa_ParentContractId != null ? c.sfa_ParentContractId.Id : Guid.Empty
                }).ToList();

                contractIds.Where(c => c.MasterContractId != Guid.Empty).ForEach(c => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, c.ContractId));
                contractIds.Where(c => c.MasterContractId == Guid.Empty).ForEach(c => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, c.ContractId));
            }
        }

        private Guid CreateTestContract(string contractNumber, int version = 0, int subVersion = 0, EntityReference parentContract = null)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_ParentContractId = parentContract,
                sfa_SubVersion = subVersion,
            };

            Guid contractId = organizationService.Create(contract);

            return contractId;
        }

        private Guid CreateTestContractWithStatus(string contractNumber, int version, sfa_contractstatus status)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetOrgEntityReference()
            };

            if (status == sfa_contractstatus.Approved)
            {
                contract.sfa_LastApprovedVersion = true;
            }

            contract.Id = organizationService.Create(contract);

            if (status != sfa_contractstatus.Draft)
            {
                contract.sfa_ContractStatus = new OptionSetValue((int)status);
                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(contract);
            }

            return contract.Id;
        }

        private static void AddTaskToContract(string contractNumber, int version)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext crmContext = new XrmServiceContext(organizationService))
            {
                EntityReference entityReference = crmContext.sfa_contractSet.Single(c => c.sfa_number == contractNumber && c.sfa_Version == version).ToEntityReference();

                var task = new Task { RegardingObjectId = entityReference };

                organizationService.Create(task);
            }
        }

        private static void AddWorkflowToContract(string contractNumber, int version)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext crmContext = new XrmServiceContext(organizationService))
            {
                EntityReference entityReference = crmContext.sfa_contractSet.Single(c => c.sfa_number == contractNumber && c.sfa_Version == version).ToEntityReference();
                var wf = new sfa_contracttransitionhistory { sfa_Contract = entityReference };

                organizationService.Create(wf);
            }
        }

        private static int GetCountOfContracts(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber).ToList().Count;
            }
        }

        private static int GetCountOfTasks(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from t in crmContext.TaskSet
                        join c in crmContext.sfa_contractSet on t.RegardingObjectId.Id equals c.sfa_contractId
                        where c.sfa_number == contractNumber && c.sfa_Version == versionNumber
                        select t).ToList().Count;
            }
        }

        private static int GetCountOfWorkflows(string contractNumber, int versionNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return (from wf in crmContext.sfa_contracttransitionhistorySet
                        join c in crmContext.sfa_contractSet on wf.sfa_Contract.Id equals c.sfa_contractId
                        where c.sfa_number == contractNumber && c.sfa_Version == versionNumber
                        select wf).ToList().Count;
            }
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private Guid CreateTestApprovedContractWithEndDate(string contractNumber, int versionNumber, int subversionNumber, DateTime contractEndDate)
        {
            IOrganizationService orgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_EndDate = contractEndDate,
            };

            Guid contractId = orgService.Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
            contract.sfa_SubStatus = GetSubStatus("Closure Initiation in Progress");
            contract.EntityState = EntityState.Changed;
            orgService.Update(contract);

            return contractId;
        }

        private List<Guid> GetUserIds()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.SystemUserSet.Select(u => u.SystemUserId.Value).ToList();
            }
        }

        private Account GetProviderForId(Guid accountId)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.SingleOrDefault(x => x.AccountId.Value == accountId);
            }
        }

        private Guid GetTransitionWithName(string transitionName)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_transitionSet.Where(t => t.sfa_name == transitionName).Select(t => t.sfa_transitionId.Value).First();
            }
        }

        private Guid AddWorkflowHistoryToContractForUser(Guid contractId, Guid userId, Guid transitionId, string transitionName)
        {
            IOrganizationService orgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contracttransitionhistory workflowItem = new sfa_contracttransitionhistory
            {
                sfa_Actionby = new EntityReference(SystemUser.EntityLogicalName, userId),
                sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_ActionOn = DateTime.Now,
                sfa_Action = new EntityReference(sfa_transition.EntityLogicalName, transitionId),
                sfa_name = transitionName
            };

            return orgService.Create(workflowItem);
        }

        private Guid CreateTestContractWithLatestVersionFlag(string contractNumber, int versionNumber, int subversionNumber, bool shouldApprove, bool isLatestVersion)
        {
            IOrganizationService orgService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = versionNumber,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetProvider(),
                sfa_SubVersion = subversionNumber,
                sfa_LatestVersion = isLatestVersion,
            };

            Guid contractId = orgService.Create(contract);

            if (shouldApprove)
            {
                contract.Id = contractId;
                contract.sfa_ContractStatus = new OptionSetValue((int)sfa_contractstatus.Approved);
                contract.sfa_SubStatus = GetSubStatus("Closure Initiation in Progress");
                contract.EntityState = EntityState.Changed;
                orgService.Update(contract);
            }

            return contractId;
        }

        private EntityReference GetSubStatus(string statusName)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_statusSet.Single(s => s.sfa_name == statusName).ToEntityReference();
            }
        }

        private EntityReference GetProvider()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                if (_providerEntityReference == null)
                {
                    var orgId = crmContext.AccountSet.Where(a => a.sfa_UKPRN != null).Select(a => a.Id).First();
                    _providerEntityReference = new EntityReference(Account.EntityLogicalName, orgId);
                }

                return _providerEntityReference;
            }
        }

        private void UpdateContractToSubStatus(Guid contractId, string subStatusName)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_SubStatus = GetSubStatus(subStatusName)
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(updatedContract);
        }

        private void UpdateContractSpecialTaskOwner(Guid contractId, Guid userId)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_specialtaskowner = new EntityReference(SystemUser.EntityLogicalName, userId)
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(updatedContract);
        }

        private void RemoveContract(string contractNumber, int version)
        {
            using (var context = new XrmServiceContext(GetConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == version)
                    .ForEach(c => GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }

        public IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory loggerFactory = new LoggerFactory();
            var container = new WindsorContainer().Install(new WindsorInstaller(loggerFactory));
            container.BeginScope();

            return container;
        }

        private FundingType GetFundingType()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var fundingType = crmContext.sfa_fundingtypeSet.First();

                return new FundingType(fundingType.sfa_fundingtypecode, fundingType.ToEntityReference());
            }
        }

        private Period GetPeriod()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var period = crmContext.sfa_periodSet.First();

                return new Period(period.sfa_Period, period.ToEntityReference());
            }
        }

        private Provider GetLocalProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var org = crmContext.AccountSet.First(a => a.sfa_UKPRN != null);

                return new Provider(org.sfa_UKPRN, org.ToEntityReference());
            }
        }

        private void CreateContractWithSubversionAndStatus(string contractNumberToTest, int version, int subVersion, sfa_contractstatus contractStatus)
        {
            Provider provider = GetLocalProvider();

            FundingType fundingType = GetFundingType();
            Period period = GetPeriod();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = provider.Ukprn,
                sfa_number = contractNumberToTest,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = provider.EntityReference,
                sfa_FundingType = fundingType.EntityReference,
                sfa_PeriodId = period.EntityReference
            };

            Guid contractId = GetConnection().Create(contract);

            var contractUpdate = new sfa_contract
            {
                Id = contractId,
                sfa_ContractStatusEnum = contractStatus
            };

            GetConnection().Update(contractUpdate);
        }

        private class Provider
        {
            public Provider(string ukprn, EntityReference entityReference)
            {
                Ukprn = ukprn;
                EntityReference = entityReference;
            }

            public string Ukprn { get; }
            public EntityReference EntityReference { get; }
        }

        private class FundingType
        {
            public FundingType(string code, EntityReference entityReference)
            {
                Code = code;
                EntityReference = entityReference;
            }

            public string Code { get; }
            public EntityReference EntityReference { get; }
        }

        private class Period
        {
            public Period(string code, EntityReference entityReference)
            {
                Code = code;
                EntityReference = entityReference;
            }

            public string Code { get; }
            public EntityReference EntityReference { get; }
        }

    }
}