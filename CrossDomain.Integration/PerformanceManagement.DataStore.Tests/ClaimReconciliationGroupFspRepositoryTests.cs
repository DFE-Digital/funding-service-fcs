namespace PerformanceManagement.DataStore.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;
    using System.Data.Entity;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReconciliationGroupFspRepositoryTests
    {
        private List<ClaimReconciliationAllocationGroupFsp> _claimAllocationGroupFsps;
        private List<ClaimReconciliationAllocationGroup> _claimAllocationGroups;

        [TestInitialize]
        public void Setup()
        {
            _claimAllocationGroups = new List<ClaimReconciliationAllocationGroup>();
            _claimAllocationGroupFsps = new List<ClaimReconciliationAllocationGroupFsp>();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                _claimAllocationGroupFsps.ForEach(fsp =>
                {
                    context.ClaimReconciliationAllocationGroupFsps.RemoveByKey(fsp.FspCode);
                });

                _claimAllocationGroups.ForEach(g =>
                {
                    context.ClaimReconciliationAllocationGroups.RemoveByKey(g.ClaimReconciliationAllocationGroupCode);
                });
                
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconAllocGroupFspRepository_WhenGetClaimReconciliationGroupIsCalled_WithFspCode_CorrectRecordIsReturned()
        {
            // Arrange
            var testFspCode = "testFsp3";
            var testAllocationGroupCode = "group3";

            CreateEntities(new ClaimReconciliationAllocationGroupFsp("group", "testFsp"), 5);

            AddAllocGroupsToDb(_claimAllocationGroups);
            AddAllocGroupFspsToDb(_claimAllocationGroupFsps);

            // Act
            var repository = new ClaimReconciliationAllocationGroupFspRepository(new PerformanceManagementDbContext());
            var allocGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod(testFspCode);

            // Assert
            Assert.IsNotNull(allocGroupFsp);
            Assert.AreEqual(testAllocationGroupCode, allocGroupFsp.ClaimReconciliationAllocationGroupCode);
            Assert.IsNotNull(allocGroupFsp.ClaimReconciliationAllocationGroup);
        }

        private void AddAllocGroupsToDb(List<ClaimReconciliationAllocationGroup> allocationGroups)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ((DbSet<ClaimReconciliationAllocationGroup>)context.ClaimReconciliationAllocationGroups)
                    .AddRange(allocationGroups);

                context.SaveChanges();
            }
        }

        private void AddAllocGroupFspsToDb(List<ClaimReconciliationAllocationGroupFsp> claimAllocGroupList)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                ((DbSet<ClaimReconciliationAllocationGroupFsp>) context.ClaimReconciliationAllocationGroupFsps)
                    .AddRange(claimAllocGroupList);
                
                context.SaveChanges();
            }
        }

        private void CreateEntities(ClaimReconciliationAllocationGroupFsp exampleClaimType, int noOfEntitiesToCreate)
        {
            for (int i = 1; i <= noOfEntitiesToCreate; i++)
            {
                _claimAllocationGroups.Add(
                    new ClaimReconciliationAllocationGroup(
                        exampleClaimType.ClaimReconciliationAllocationGroupCode + i,
                        exampleClaimType.ClaimReconciliationAllocationGroupCode + "Name" + i));

                _claimAllocationGroupFsps.Add(
                    new ClaimReconciliationAllocationGroupFsp(
                        exampleClaimType.ClaimReconciliationAllocationGroupCode + i,
                        exampleClaimType.FspCode + i));
            }
        }
    }
}
