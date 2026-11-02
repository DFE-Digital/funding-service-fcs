namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractNotification.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Xrm.ContractNotification.Repositories;

    [TestClass]
    public class CrmNotificationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmNotificationRepository_ShouldCreateContractClosureInitiateFailedNotificationForUser()
        {
            // arrange
            const string contractNumber = "TEST-9911";
            const int versionNumber = 1;
            const string ukprn = "19945823";
            const string providerName = "TEST PROVIDER LTD";
            const string reasonText = "it has outstanding payments";

            string expectedName = $"Contract Closure Initiation Failed - {contractNumber}";
            string expectedText = $"Contract {contractNumber} v{versionNumber} for provider {ukprn} ({providerName}) cannot be closed - {reasonText}";

            Guid userId = GetUserId("FCS8 TEST");

            ClearNotificationsForUser(userId);

            ICrmNotificationRepository repository = new CrmNotificationRepository(GetCrmConnection());

            // act
            repository.CreateNotificationForUser(
                notificationType: sfa_notificationtype.ContractClosureInitiationFailed,
                notificationName: expectedName,
                notificationText: expectedText,
                userId: userId);

            // assert
            sfa_notification actualNotification = GetNotificationForUser(userId);

            Assert.IsNotNull(actualNotification, "No notification was created");
            Assert.AreEqual((int)sfa_notificationtype.ContractClosureInitiationFailed, actualNotification.sfa_NotificationType.Value,
                "Notification type was incorrect");
            Assert.AreEqual(expectedName, actualNotification.sfa_Name, "Notification name was incorrect");
            Assert.AreEqual(expectedText, actualNotification.sfa_Notification, "Notification text was incorrect");
        }

        private void ClearNotificationsForUser(Guid userId)
        {
            var crmConnection = GetCrmConnection();
            using (var crmContext = new XrmServiceContext(crmConnection))
            {
                List<sfa_notification> notifications =
                    (from n in crmContext.sfa_notificationSet
                     join u in crmContext.SystemUserSet
                        on n.OwnerId.Id equals u.SystemUserId.Value
                     where u.SystemUserId != null
                        && u.SystemUserId.Value == userId
                     select n).ToList();

                notifications.ForEach(n => crmConnection.Delete(n.LogicalName, n.Id));
            }
        }

        private Guid GetUserId(string username)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.SystemUserSet.Single(u => u.FullName == username).Id;
            }
        }

        private sfa_notification GetNotificationForUser(Guid userId)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return (from n in crmContext.sfa_notificationSet
                        join u in crmContext.SystemUserSet
                           on n.OwnerId.Id equals u.SystemUserId.Value
                        where u.SystemUserId != null
                           && u.SystemUserId.Value == userId
                        select n).First();
            }
        }

        private IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}