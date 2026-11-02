namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractNotification.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Xrm.ContractNotification.Dtos;
    using Xrm.ContractNotification.Repositories;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        private EntityReference _providerEntityReference;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldGetProviderInformation()
        {
            // arrange
            const string contractNumber = "TEST-9750";
            const int versionNumber = 1;
            const int subversionNumber = 0;

            DeleteContracts(contractNumber);
            CreateTestApprovedContractWithEndDate(contractNumber, versionNumber, subversionNumber, DateTime.Now);
            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            Account expectedProvider = GetProviderForId(_providerEntityReference.Id);

            // act
            ProviderInfo provider = repository.GetProviderInfoForContract(contractNumber, versionNumber, subversionNumber);

            // assert
            Assert.IsNotNull(provider, "Did not get a provider for the contract");
            Assert.AreEqual(expectedProvider.sfa_UKPRN, provider.Ukprn, "Ukprn was not as expected");
            Assert.AreEqual(expectedProvider.Name, provider.ProviderName, "Provider name was not as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldGetProviderInformationForAnySubversion()
        {
            // arrange
            const string contractNumber = "TEST-9750";
            const int versionNumber = 1;

            DeleteContracts(contractNumber);
            CreateTestContractWithStatus(contractNumber, versionNumber, sfa_contractstatus.SupersededDraft);
            CreateTestContractWithStatus(contractNumber, versionNumber, sfa_contractstatus.Draft);

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            Account expectedProvider = GetProviderForId(_providerEntityReference.Id);

            // act
            ProviderInfo provider = repository.GetProviderInfoForContract(contractNumber, versionNumber);

            // assert
            Assert.IsNotNull(provider, "Did not get a provider for the contract");
            Assert.AreEqual(expectedProvider.sfa_UKPRN, provider.Ukprn, "Ukprn was not as expected");
            Assert.AreEqual(expectedProvider.Name, provider.ProviderName, "Provider name was not as expected");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldGetLatestUserIdAssociatedWithWorkflowItemForContract()
        {
            // arrange
            const string contractNumber = "TEST-9752";
            const int versionNumber = 1;
            const int subversionNumber = 0;
            const string transitionName = "Initiate Contract Closure";
            const string transitionName2 = "Approve Closure";

            DeleteContracts(contractNumber);

            List<Guid> firstTwoUserIds = GetUserIds().Take(2).ToList();
            Guid contractId = CreateTestContractWithLatestVersionFlag(contractNumber, versionNumber, subversionNumber, shouldApprove: false, isLatestVersion: true);
            Guid transitionId = GetTransitionWithName(transitionName);
            Guid transitionId2 = GetTransitionWithName(transitionName2);
            AddWorkflowHistoryToContractForUser(contractId, firstTwoUserIds[0], transitionId, transitionName);
            AddWorkflowHistoryToContractForUser(contractId, firstTwoUserIds[1], transitionId2, transitionName2);

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            Guid actualId = repository.GetLatestUserIdAssociatedWithWorkflowItemForContract(contractNumber,
                versionNumber,
                subversionNumber,
                transitionName);

            // assert
            Assert.AreEqual(firstTwoUserIds[0], actualId, "Incorrect user ID was returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetLatestUserIdAssociatedWithWorkflowItemForContract_ShouldGetLastUserIdForWorkflowHistoryItemOnContract()
        {
            // arrange
            const string contractNumber = "TEST-9752";
            const int versionNumber = 1;
            const int subversionNumber = 0;
            const string initiateContractClosureTransitionName = "Initiate Contract Closure";

            DeleteContracts(contractNumber);

            List<Guid> userIds = GetUserIds();
            Guid firstUser = userIds[0];
            Guid secondUser = userIds[2];

            Guid contractId = CreateTestContractWithLatestVersionFlag(contractNumber, versionNumber, subversionNumber, shouldApprove: false, isLatestVersion: true);
            Guid transitionId = GetTransitionWithName(initiateContractClosureTransitionName);

            AddWorkflowHistoryToContractForUser(contractId, firstUser, transitionId, initiateContractClosureTransitionName);
            System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(2)).Wait(); // ensure some time elapses between transitions
            AddWorkflowHistoryToContractForUser(contractId, secondUser, transitionId, initiateContractClosureTransitionName);

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            Guid latestUserId = repository.GetLatestUserIdAssociatedWithWorkflowItemForContract(contractNumber,
                versionNumber,
                subversionNumber,
                initiateContractClosureTransitionName);

            // assert
            Assert.AreEqual(secondUser, latestUserId, "Incorrect latest user ID was returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_ShouldGetSpecialTaskOwnerUserContractWithSubStatus()
        {
            // arrange
            const string contractNumber = "TEST-9752";
            const int versionNumber = 1;
            const string deleteInProgressSubStatus = "Delete In Progress";

            DeleteContracts(contractNumber);

            Guid userId = GetUserIds()[2];

            Guid contractId = CreateTestContractWithStatus(contractNumber, versionNumber, sfa_contractstatus.Draft);

            // the following two steps are what the Delete CRM Workflow does
            // when a user clicks the "Delete Draft" button
            UpdateContractToSubStatus(contractId, deleteInProgressSubStatus);
            UpdateContractSpecialTaskOwner(contractId, userId);

            ICrmContractRepository repository = new CrmContractRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            // act
            Guid latestUserId = repository.GetSpecialTaskOwnerUserForContractWithSubStatus(contractNumber,
                versionNumber,
                deleteInProgressSubStatus);

            // assert
            Assert.AreEqual(userId, latestUserId, "Incorrect latest user ID was returned");
        }

        private static void DeleteContracts(string contractNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var contractIds = crmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => new 
                    {
                        ContractId = c.sfa_contractId.Value,
                        MasterContractId = c.sfa_ParentContractId != null ? c.sfa_ParentContractId.Id : Guid.Empty
                    }).ToList();

                contractIds.Where(c => c.MasterContractId != Guid.Empty).ForEach(c => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, c.ContractId));
                contractIds.Where(c => c.MasterContractId == Guid.Empty).ForEach(c => CrmConnectionFactory.GetRetryOnErrorOrganizationService().Delete(sfa_contract.EntityLogicalName, c.ContractId));
            }
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

            contract.Id = organizationService.Create(contract);

            if (status != sfa_contractstatus.Draft)
            {
                contract.sfa_ContractStatus = new OptionSetValue((int)status);
                CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(contract);
            }

            return contract.Id;
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

        private void CreateTestApprovedContractWithEndDate(string contractNumber, int versionNumber, int subversionNumber, DateTime contractEndDate)
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
        }

        private static List<Guid> GetUserIds()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.SystemUserSet.Select(u => u.SystemUserId.Value).ToList();
            }
        }

        private static Account GetProviderForId(Guid accountId)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.SingleOrDefault(x => x.AccountId.Value == accountId);
            }
        }

        private static Guid GetTransitionWithName(string transitionName)
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_transitionSet.Where(t => t.sfa_name == transitionName).Select(t => t.sfa_transitionId.Value).First();
            }
        }

        private static void AddWorkflowHistoryToContractForUser(Guid contractId, Guid userId, Guid transitionId, string transitionName)
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

            orgService.Create(workflowItem);
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

        private static EntityReference GetSubStatus(string statusName)
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

        private static void UpdateContractToSubStatus(Guid contractId, string subStatusName)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_SubStatus = GetSubStatus(subStatusName)
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(updatedContract);
        }

        private static void UpdateContractSpecialTaskOwner(Guid contractId, Guid userId)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_specialtaskowner = new EntityReference(SystemUser.EntityLogicalName, userId)
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Update(updatedContract);
        }

        public IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

    }
}