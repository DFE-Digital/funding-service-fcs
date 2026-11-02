namespace PerformanceManagement.DataStore.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReferenceProfileRepositoryTests
    {
        private const string ClaimReconciliationDeliverableGroupCodeTest = "Test_Code_Repository_Test";
        private const int UkprnTest = 87654321;
        private const decimal PlannedValueTest = 150.00m;

        [TestCleanup]
        public void CleanUp()
        {
            var claimReconciliationReferenceDataProfile = new ClaimReconciliationReferenceDataProfile(
                    ClaimReconciliationDeliverableGroupCodeTest,
                    UkprnTest,
                    PlannedValueTest);

            RemoveTestClaimReconciliationReferenceDataProfile(claimReconciliationReferenceDataProfile);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReferenceProfileRepository_GetPlannedValue_ShouldReturnValueWhenProfileExistsInTable()
        {
            // Arrange
            var claimReconciliationReferenceDataProfile = new ClaimReconciliationReferenceDataProfile(
                    ClaimReconciliationDeliverableGroupCodeTest,
                    UkprnTest,
                    PlannedValueTest);

            RemoveTestClaimReconciliationReferenceDataProfile(claimReconciliationReferenceDataProfile);
            AddClaimReconciliationReferenceDataProfileToDb(claimReconciliationReferenceDataProfile);

            // Act
            decimal? plannedValue;
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new ClaimReferenceProfileRepository(context);
                plannedValue = repository.GetPlannedValue(ClaimReconciliationDeliverableGroupCodeTest, UkprnTest);
            }

            // Assert
            Assert.AreEqual(PlannedValueTest, plannedValue);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReferenceProfileRepository_GetPlannedValue_ShouldReturnNullWhenProfileDoesNotExistInTable()
        {
            // Arrange
            var claimReconciliationReferenceDataProfile = new ClaimReconciliationReferenceDataProfile(
                    ClaimReconciliationDeliverableGroupCodeTest,
                    UkprnTest,
                    PlannedValueTest);

            RemoveTestClaimReconciliationReferenceDataProfile(claimReconciliationReferenceDataProfile);
            AddClaimReconciliationReferenceDataProfileToDb(claimReconciliationReferenceDataProfile);

            // Act
            decimal? plannedValue;
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new ClaimReferenceProfileRepository(context);
                plannedValue = repository.GetPlannedValue(ClaimReconciliationDeliverableGroupCodeTest, 9999);
            }

            // Assert
            Assert.IsNull(plannedValue);
        }

        private static void AddClaimReconciliationReferenceDataProfileToDb(ClaimReconciliationReferenceDataProfile claimReconciliationReferenceDataProfile)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationReferenceDataProfiles.Add(claimReconciliationReferenceDataProfile);

                context.SaveChanges();
            }
        }
       
        private static void RemoveTestClaimReconciliationReferenceDataProfile(ClaimReconciliationReferenceDataProfile claimReconciliationReferenceDataProfile)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationReferenceDataProfiles.RemoveByKey(
                    claimReconciliationReferenceDataProfile.ClaimReconciliationDeliverableGroupCode,
                    claimReconciliationReferenceDataProfile.Ukprn);

                context.SaveChanges();
            }
        }
    }
}
