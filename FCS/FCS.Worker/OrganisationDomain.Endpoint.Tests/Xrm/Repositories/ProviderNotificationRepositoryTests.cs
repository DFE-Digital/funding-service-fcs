namespace OrganisationDomain.Endpoint.Tests.Xrm.Repositories
{
    using System.Linq;
    using Endpoint.Xrm.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class ProviderNotificationRepositoryTests
    {
        private const string TestNotificationText = "test notification message";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProviderNotificationRepository_CreateProviderDetailsUpdatedNotification_ShouldCreateNotificationInCrmWhenGivenValidUkprnAndNotificationText()
        {
            TestCleanup();

            // Arrange
            Account testProvider = GetFirstOrganisationInCrm();
            Team expectedOwner = GetTeam("Contract Managers Team");
            ProviderNotificationRepository notificationRepository =
                new ProviderNotificationRepository(GetOrganizationService(), new TeamRepository());

            // Act
            notificationRepository.CreateProviderDetailsUpdatedNotification(int.Parse(testProvider.sfa_UKPRN), TestNotificationText);

            // Assert
            sfa_notification retrievedNotification = RetrieveNotificationForNotificationName(TestNotificationText);
            Assert.AreEqual((int)sfa_notificationtype.ProviderDetailsUpdated, retrievedNotification.sfa_NotificationType.Value);
            Assert.AreEqual($"Provider Details Updated - {testProvider.sfa_UKPRN}", retrievedNotification.sfa_Name);
            Assert.AreEqual(expectedOwner.ToEntityReference().Id, retrievedNotification.OwnerId.Id);
            Assert.AreEqual(TestNotificationText, retrievedNotification.sfa_Notification);
            Assert.AreEqual(testProvider.Id, retrievedNotification.sfa_provider.Id);
        }

        private static Team GetTeam(string teamName)
        {
            using (var xrmServiceContext = new XrmServiceContext(GetOrganizationService()))
            {
                return xrmServiceContext.TeamSet.Single(t => t.Name == teamName);
            }
        }

        private static sfa_notification RetrieveNotificationForNotificationName(string notificationName)
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                return xrmContext.sfa_notificationSet.FirstOrDefault(n => n.sfa_Notification == notificationName);
            }
        }

        private static void TestCleanup()
        {
            using (var xrmServiceContext = new XrmServiceContext(GetOrganizationService()))
            {
                var sfaNotifications =
                    xrmServiceContext.sfa_notificationSet.Where(n => n.sfa_Notification == TestNotificationText).Select(n => n.Id)
                    .ToList();

                sfaNotifications.ForEach(n =>
                {
                    GetOrganizationService().Delete(sfa_notification.EntityLogicalName, n);
                });
            }
        }

        private static IOrganizationService GetOrganizationService()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static Account GetFirstOrganisationInCrm()
        {
            using (var xrmContext = new XrmServiceContext(GetOrganizationService()))
            {
                var orgs = xrmContext.AccountSet.Where(a => a.sfa_UKPRN != null && a.sfa_UKPRN != string.Empty)
                                                .Select(a => new { a.sfa_UKPRN, a.AccountId })
                                                .ToList();
                var orgWithUniqueUkprn = orgs.GroupBy(ag => ag.sfa_UKPRN)
                                             .First(ag => ag.Count() == 1)
                                             .Single();

                return xrmContext.AccountSet.Single(a => a.Id == orgWithUniqueUkprn.AccountId);
            }
        }
    }
}
