namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.CrmRepositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;

    [TestClass]
    public class CRMAllocationNotificationDataTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CRMAllocationNotificationData_ShouldCreateNotificationName()
        {
            const string fundingStreamName = "Some FS";
            const string allocationNumber = "Some Alloc";

            CRMAllocationNotificationData allocationNotificationData = new CRMAllocationNotificationData(fundingStreamName, allocationNumber, 1, 111, "some");
            // act
            string notificationName = allocationNotificationData.CreateNotificationName();

            Assert.AreEqual("Amendment Approval-Allocation Some Alloc - Some FS", notificationName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NotificationTextCreator_ShouldCreateNotificationText()
        {
            const string fundingStreamName = "Some FS";
            const string allocationNumber = "Some Alloc";
            const int contractVersionNumber = 1;
            const int ukprn = 12345678;
            const string legalName = "Some Legal";

            CRMAllocationNotificationData allocationNotificationData = new CRMAllocationNotificationData(fundingStreamName, allocationNumber, contractVersionNumber, ukprn, legalName);

            // act
            string notificationText = allocationNotificationData.CreateNotificationText();

            Assert.AreEqual("Some Alloc v1 (12345678: Some Legal) approved", notificationText);
        }
    }
}