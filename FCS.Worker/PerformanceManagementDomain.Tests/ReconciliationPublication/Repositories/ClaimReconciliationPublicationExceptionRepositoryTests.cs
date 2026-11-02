namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReconciliationPublicationExceptionRepositoryTests
    {
        private const string CommonTestClaimReconciliationAllocationGroupCode = "AEBC1617";
        private const int CommonTestUkprn = 12345678;
        private static readonly IReadOnlyCollection<ClaimReconciliationPublicationException> TestData = new List<ClaimReconciliationPublicationException>()
        {
            new ClaimReconciliationPublicationException(CommonTestClaimReconciliationAllocationGroupCode, CommonTestUkprn),
            new ClaimReconciliationPublicationException(CommonTestClaimReconciliationAllocationGroupCode, 12345677)
        };

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionRepository_IsForManualPublication_ShouldReturnTrueWhenUkprnAndClaimReconciliationAllocationGroupCodeMatchRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool isExceptional;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationExceptionRepository repository = new ClaimReconciliationPublicationExceptionRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                isExceptional = repository.IsForManualPublication(connectionInfo, CommonTestClaimReconciliationAllocationGroupCode, CommonTestUkprn).Result;
            }

            // Assert
            Assert.IsTrue(isExceptional, "Expected IsForManualPublication to return true, but got false");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionRepository_IsForManualPublication_ShouldReturnFalseWhenOnlyClaimReconciliationAllocationGroupCodeMatchesRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool isExceptional;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationExceptionRepository repository = new ClaimReconciliationPublicationExceptionRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                isExceptional = repository.IsForManualPublication(connectionInfo, CommonTestClaimReconciliationAllocationGroupCode, 123456).Result;
            }

            // Assert
            Assert.IsFalse(isExceptional, "Expected IsForManualPublication to return false, but got true");
            CleanUpTestData();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionRepository_IsForManualPublication_ShouldReturnFalseWhenOnlyUkprnMatchesRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool isExceptional;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationExceptionRepository repository = new ClaimReconciliationPublicationExceptionRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                isExceptional = repository.IsForManualPublication(connectionInfo, "AAC1617", CommonTestUkprn).Result;
            }

            // Assert
            Assert.IsFalse(isExceptional, "Expected IsForManualPublication to return false, but got true");
            CleanUpTestData();
        }

        private static void SetupWithTestData()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                TestData.ToList().ForEach(td => context.ClaimReconciliationPublicationExceptions.Add(td));
                context.SaveChanges();
            }
        }

        private static void CleanUpTestData()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                TestData.ToList().ForEach(
                    td =>
                        context.ClaimReconciliationPublicationExceptions.RemoveWhere(
                            cr => cr.ClaimReconciliationAllocationGroupCode == td.ClaimReconciliationAllocationGroupCode && cr.Ukprn == td.Ukprn));
                context.SaveChanges();
            }
        }
    }
}
