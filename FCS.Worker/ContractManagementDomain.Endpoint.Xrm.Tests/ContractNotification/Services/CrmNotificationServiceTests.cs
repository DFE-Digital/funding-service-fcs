namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractNotification.Services
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Collections.Generic;
    using SFA.FCS.Worker.Common.Crm;
    using Xrm.ContractNotification.Dtos;
    using Xrm.ContractNotification.Repositories;
    using Xrm.ContractNotification.Services;

    [TestClass]
    public class CrmNotificationServiceTests
    {
        private EntityReference _providerEntityReference = null;
        private EntityReference _userEntityReference = null;

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForInitiateClosureOfContractFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-321";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text";
            const string transitionName = "Initiate Contract Closure";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateInitiateClosureFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Contract Closure Initiation Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be closed - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractClosureInitiationFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForApproveClosureOfContractFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text 2";
            const string transitionName = "Approve Closure";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateApproveClosureFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Contract Closure Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be closed - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractClosureFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractAmendmentFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text 2";
            const string transitionName = "Initiate Contract Closure";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateContractAmendmentFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Contract Amendment Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be amended - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractAmendmentFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractAmendmentFailedWhenReasonIsInitiateTerminationFound()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text 2";
            const string transitionName = "Initiate Contract Termination";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.InitiateContractTerminationFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateContractAmendmentFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Contract Amendment Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be amended - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractAmendmentFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractNonFinancialVariationFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text 2";
            const string transitionName = "Initiate Non-Financial Amendment (Vary)";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateContractVariationNonFinancialAmendmentFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Non-Financial Contract Amendment Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be amended - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.NonFinancialContractAmendmentFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractNonFinancialNotificationFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text 2";
            const string transitionName = "Initiate Non-Financial Amendment (Notify)";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);
            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateContractNotificationNonFinancialAmendmentFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Non-Financial Contract Amendment Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version, subVersion);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be amended - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.NonFinancialContractAmendmentFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForDeleteDraftContractFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractClosureFound, string.Empty, string.Empty);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);

            // the following two lines are simulating the CRM workflow actions for delete draft
            // since there is no transition or workflow history for this process we have to use special task owner
            // which is set to the initiating user as the substatus is updated
            UpdateContractToSubStatus(contractId, "Delete In Progress");
            UpdateContractSpecialTaskOwner(contractId, GetUserEntityReference());

            // act
            notificationService.CreateDeleteDraftContractFailedNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Draft Contract Deletion Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be deleted - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractDeletionFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractTerminationFailed()
        {
            // arrange
            const string contractNumber = "NOTIFY-322";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text";
            const string transitionName = "Contract Termination Failed";
            const string notificationName = "Contract Termination Failed";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.ContractTerminationValidationFailed,
                transitionName, notificationName);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);

            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"Contract Termination Failed - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be terminated - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int) sfa_notificationtype.ContractTerminationFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationService_ShouldCreateNotificationForContractAmendmentFailedDueToAwaitingModificationApproval()
        {
            // arrange
            const string contractNumber = "Some CN123";
            const int version = 1;
            const int subVersion = 0;
            const string notificationText = "dummy notification text";
            const string transitionName = "Initiate Contract Modification";
            const string notificationName = "Contract Amendment Failed";

            NotificationInfo notificationInfo = new NotificationInfo(contractNumber, version, subVersion,
                notificationText, NotificationInfo.NotificationReason.AwaitingModificationApprovalFound,
                transitionName, notificationName);

            IOrganizationService orgService = GetCrmConnection();
            ICrmContractRepository contractRepository = new CrmContractRepository(orgService);
            ICrmNotificationRepository notificationRepository = new CrmNotificationRepository(orgService);
            ICrmNotificationService notificationService = new CrmNotificationService(contractRepository, notificationRepository);

            DeleteTestContract(contractNumber);
            DeleteNotificationsForUser(GetUserEntityReference().Id);
            Guid contractId = CreateTestContract(contractNumber, version, subVersion);

            AddWorkflowHistoryToContract(contractId, transitionName);

            // act
            notificationService.CreateNotificationForContract(notificationInfo);

            // assert
            // create expected information
            sfa_notification notification = GetNotificationForUser(GetUserEntityReference().Id);
            string expectedName = $"{notificationName} - {contractNumber}";
            ProviderInfo provider = contractRepository.GetProviderInfoForContract(contractNumber, version);
            string expectedMessage = $"Contract {contractNumber} v{version} for provider {provider.Ukprn} ({provider.ProviderName}) cannot be amended - {notificationText}";

            Assert.IsNotNull(notification, "No notification was found");
            Assert.AreEqual(expectedName, notification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedMessage, notification.sfa_Notification, "Notification text was incorrect");
            Assert.AreEqual((int)sfa_notificationtype.ContractAmendmentFailed, notification.sfa_NotificationType.Value, "Incorrect notification type");
        }

        private static void DeleteNotificationsForUser(Guid userId)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                List<sfa_notification> notifications =
                    (from n in crmContext.sfa_notificationSet
                        join u in crmContext.SystemUserSet
                            on n.OwnerId.Id equals u.SystemUserId.Value
                        where u.SystemUserId != null
                              && u.SystemUserId.Value == userId
                        select n).ToList();

                notifications.ForEach(n => { GetCrmConnection().Delete(sfa_notification.EntityLogicalName, n.Id); });
            }
        }

        private static void DeleteTestContract(string contractNumber)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                List<Guid> contractIds = crmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_contractId.Value)
                    .ToList();

                contractIds.ForEach(c => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, c));

                crmContext.SaveChanges();
            }
        }

        private static sfa_notification GetNotificationForUser(Guid userId)
        {
            using (XrmServiceContext crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return (from n in crmContext.sfa_notificationSet
                    join u in crmContext.SystemUserSet
                        on n.OwnerId.Id equals u.SystemUserId.Value
                    where u.SystemUserId != null
                          && u.SystemUserId.Value == userId
                    select n).First();
            }
        }

        private void AddWorkflowHistoryToContract(Guid contractId, string transitionName)
        {
            IOrganizationService orgService = GetCrmConnection();

            sfa_contracttransitionhistory workflowItem = new sfa_contracttransitionhistory
            {
                sfa_Actionby = GetUserEntityReference(),
                sfa_Contract = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_ActionOn = DateTime.Now,
                sfa_Action = GetTransitionEntityReferenceWithName(transitionName)
            };

            Guid workflowId = orgService.Create(workflowItem);

            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_contractId = contractId,
                sfa_LastWorkflowHistory = new EntityReference(sfa_contracttransitionhistory.EntityLogicalName, workflowId)
            };

            orgService.Update(contract);
        }

        private Guid CreateTestContract(string contractNumber, int version, int subVersion)
        {
            IOrganizationService orgService = GetCrmConnection();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_SubVersion = subVersion,
            };

            Guid contractId = orgService.Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int) sfa_contractstatus.Approved);
            contract.sfa_SubStatus = GetContractClosureInitiationInProgressSubStatus();
            contract.EntityState = EntityState.Changed;
            orgService.Update(contract);

            return contractId;
        }

        private static EntityReference GetContractClosureInitiationInProgressSubStatus()
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.sfa_statusSet.First(s => s.sfa_name == "Closure Initiation in Progress").ToEntityReference();
            }
        }

        private static EntityReference GetSubStatus(string subStatus)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private EntityReference GetOrgEntityReference()
        {
            if (_providerEntityReference == null)
            {
                using (XrmServiceContext crmContext = new XrmServiceContext(GetCrmConnection()))
                {
                    _providerEntityReference = crmContext.AccountSet.First().ToEntityReference();
                }
            }

            return _providerEntityReference;
        }

        private EntityReference GetUserEntityReference()
        {
            if (_userEntityReference == null)
            {
                const string userFullName = "CRM Integration";

                using (XrmServiceContext crmContext = new XrmServiceContext(GetCrmConnection()))
                {

                    Guid userId = crmContext.SystemUserSet.Single(u => u.FullName == userFullName).SystemUserId.Value;

                    _userEntityReference = new EntityReference(SystemUser.EntityLogicalName, userId);
                }
            }

            return _userEntityReference;
        }

        private static EntityReference GetTransitionEntityReferenceWithName(string transitionName)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.sfa_transitionSet.First(t => t.sfa_name == transitionName).ToEntityReference();
            }
        }

        private void UpdateContractToSubStatus(Guid contractId, string subStatus)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_SubStatus = GetSubStatus(subStatus)
            };

            GetCrmConnection().Update(updatedContract);
        }

        private void UpdateContractSpecialTaskOwner(Guid contractId, EntityReference userEntityReference)
        {
            sfa_contract updatedContract = new sfa_contract
            {
                Id = contractId,
                sfa_specialtaskowner = userEntityReference
            };

            GetCrmConnection().Update(updatedContract);
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}