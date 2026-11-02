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
    public class ClaimReconciliationReferenceDataReconProfilingRepositoryTests
    {
        private const string FundingPeriod = "AEBC1617";
        private const int CommonTestUkprn = 12345678;
        private static readonly IReadOnlyCollection<ClaimReconciliationReferenceDataReconProfiling> TestData = 
            new List<ClaimReconciliationReferenceDataReconProfiling>()
        {
            new ClaimReconciliationReferenceDataReconProfiling(FundingPeriod, CommonTestUkprn),
            new ClaimReconciliationReferenceDataReconProfiling(FundingPeriod, 12345677)
        };

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingRepository_ShouldStaggerPayments_ShouldReturnTrueWhenFundingPeriodAndUkprnMatchRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool shouldStaggerPayments;
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new ClaimReconciliationReferenceDataReconProfilingRepository();
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                shouldStaggerPayments = repository.ShouldStaggerPayments(connectionInfo, FundingPeriod, CommonTestUkprn).Result;
            }

            // Assert
            Assert.IsTrue(shouldStaggerPayments, "Expected ShouldStaggerPayments to return true, but got false");
            CleanUpTestData();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingRepository_ShouldStaggerPayments_ShouldReturnFalseWhenOnlyFundingPeriodMatchesRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool shouldStaggerPayments;
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new ClaimReconciliationReferenceDataReconProfilingRepository();
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                shouldStaggerPayments = repository.ShouldStaggerPayments(connectionInfo, FundingPeriod, 123456).Result;
            }

            // Assert
            Assert.IsFalse(shouldStaggerPayments, "Expected ShouldStaggerPayments to return false, but got true");
            CleanUpTestData();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingRepository_ShouldStaggerPayments_ShouldReturnFalseWhenOnlyUkprnMatchesRowInDatabase()
        {
            // Arrange
            CleanUpTestData();
            SetupWithTestData();

            bool shouldStaggerPayments;
            using (var context = new PerformanceManagementDbContext())
            {
                var repository = new ClaimReconciliationReferenceDataReconProfilingRepository();
                var connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                // Act
                shouldStaggerPayments = repository.ShouldStaggerPayments(connectionInfo, "AAC1617", CommonTestUkprn).Result;
            }

            // Assert
            Assert.IsFalse(shouldStaggerPayments, "Expected ShouldStaggerPayments to return false, but got true");
            CleanUpTestData();
        }


        private static void SetupWithTestData()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                TestData.ToList().ForEach(td => context.ClaimReconciliationReferenceDataReconProfilings.Add(td));
                context.SaveChanges();
            }
        }

        private static void CleanUpTestData()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                TestData.ToList().ForEach(
                    td =>
                        context.ClaimReconciliationReferenceDataReconProfilings.RemoveWhere(
                            crrdrp => crrdrp.FundingPeriod == td.FundingPeriod && crrdrp.Ukprn == td.Ukprn));
                context.SaveChanges();
            }
        }

    }
}