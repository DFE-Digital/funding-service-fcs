namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReferenceProfileRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReferenceProfileRepository_IsProfileFromReferenceData_ShouldReturnTrue()
        {
            // arrange
            const string claimReconciliationDeliverableGroupCode = "CodeIsProfileFromReferenceData";
            const string claimReconciliationDeliverableGroupName = "Tests ClaimReferenceProfileRepository IsProfileFromReferenceData";
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationDeliverableGroups.RemoveWhere(crdg =>
                    crdg.ClaimReconciliationDeliverableGroupCode == claimReconciliationDeliverableGroupCode);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                var claimReconciliationAllocationGroup = new ClaimReconciliationDeliverableGroup(claimReconciliationDeliverableGroupCode,
                    claimReconciliationDeliverableGroupName, capClaimToProfile: true, obtainProfileFromReferenceData: true);

                context.ClaimReconciliationDeliverableGroups.Add(claimReconciliationAllocationGroup);

                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var claimReferenceProfileRepository = new ClaimReferenceProfileRepository();
                // act
                var IsProfileFromReferenceDataAssert = claimReferenceProfileRepository
                    .IsProfileFromReferenceData(claimReconciliationDeliverableGroupCode, connectionInfo)
                    .Result;

                // assert
                Assert.IsTrue(IsProfileFromReferenceDataAssert, "Incorrect boolean value returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReferenceProfileRepository_GetPlannedValue_ShouldReturnCorrectValue()
        {
            // arrange
            const string claimReconciliationDeliverableGroupCode = "CodeGetPlannedValue";
            const int ukprn = 8165237;
            const decimal plannedValue = (decimal)789.01;

            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationReferenceDataProfiles.RemoveWhere(crrd =>
                    crrd.ClaimReconciliationDeliverableGroupCode == claimReconciliationDeliverableGroupCode);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                var claimReconciliationReferenceDataProfile = new ClaimReconciliationReferenceDataProfile(claimReconciliationDeliverableGroupCode, ukprn, plannedValue);

                context.ClaimReconciliationReferenceDataProfiles.Add(claimReconciliationReferenceDataProfile);

                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var claimReferenceProfileRepository = new ClaimReferenceProfileRepository();
                // act
                var plannedValueAssert = claimReferenceProfileRepository.GetPlannedValue(claimReconciliationDeliverableGroupCode, ukprn, connectionInfo).Result;

                // assert
                Assert.AreEqual(plannedValue, plannedValueAssert, "Incorrect planned value returned");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReferenceProfileRepository_GetPlannedValue_ShouldReturnNullWhenProfileDoesNotExistInTable()
        {
            const string claimReconciliationDeliverableGroupCode = "CodeGetPlannedValue";
            const int ukprn = 8165237;
            const decimal plannedValue = (decimal)789.01;

            // Arrange
            var claimReconciliationReferenceDataProfile = new ClaimReconciliationReferenceDataProfile(
                claimReconciliationDeliverableGroupCode,
                ukprn,
                plannedValue);

            RemoveTestClaimReconciliationReferenceDataProfile(claimReconciliationReferenceDataProfile);
            
            // Act
            decimal? plannedValueRetrieved = new ClaimReferenceProfileRepository().GetPlannedValue(
                claimReconciliationDeliverableGroupCode,
                ukprn,
                connectionInfo:new ConnectionInfo(transaction:null, connection: new PerformanceManagementDbContext().Database.Connection)).Result;
          
            // Assert
            Assert.IsNull(plannedValueRetrieved);
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