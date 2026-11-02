namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Collections.Generic;
    using System.Data.Entity;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReconciliationAllocationGroupFspRepositoryTests
    {
        private const string ClaimReconciliationAllocationGroupTest = "SomeGroup";
        private const string FspCodeTest = "SomeFSP";

        private List<ClaimReconciliationAllocationGroupFsp> _claimAllocationGroupFsps;
        private List<ClaimReconciliationAllocationGroup> _claimAllocationGroups;

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                foreach (var groupFsp in context.ClaimReconciliationAllocationGroupFsps.Where(gfsp => gfsp.FspCode == FspCodeTest))
                {
                    context.ClaimReconciliationAllocationGroupFsps.Remove(groupFsp);
                }

                context.ClaimReconciliationAllocationGroups
                    .Where(g => g.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupTest).ToList()
                    .ForEach(g => context.ClaimReconciliationAllocationGroups.Remove(g));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_ShouldReturnNull_When_GetClaimAllocationGroupForFundingStreamPeriod_Is_CalledForNonExistingFsp()
        {
            // arrange 
            ClaimReconciliationAllocationGroupFsp claimReconciliationAllocationGroupFsp = null;
            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository();

                // act
                claimReconciliationAllocationGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod("X", connectionInfo).Result;
            }

            // assert
            Assert.AreEqual(null, claimReconciliationAllocationGroupFsp);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_ShouldReturnPopulated_When_GetClaimAllocationGroupForFundingStreamPeriod_Is_CalledForExistingFsp()
        {
            // arrange 
            ClaimReconciliationAllocationGroupFsp claimReconciliationAllocationGroupFsp =
                new ClaimReconciliationAllocationGroupFsp(ClaimReconciliationAllocationGroupTest, FspCodeTest)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(ClaimReconciliationAllocationGroupTest, "Desc")
                };

            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationAllocationGroupFsps.Add(claimReconciliationAllocationGroupFsp);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository();

                // act
                claimReconciliationAllocationGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod(FspCodeTest, connectionInfo).Result;
            }

            // assert
            Assert.IsNotNull(claimReconciliationAllocationGroupFsp);
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconAllocGroupFspRepository_WhenGetClaimReconciliationGroupIsCalled_WithFspCode_CorrectRecordIsReturned()
        {
            // Arrange
            _claimAllocationGroups = new List<ClaimReconciliationAllocationGroup>();
            _claimAllocationGroupFsps = new List<ClaimReconciliationAllocationGroupFsp>();

            var testFspCode = "testFsp3";
            var testAllocationGroupCode = "group3";

            CreateEntities(new ClaimReconciliationAllocationGroupFsp("group", "testFsp"), 5);

            AddAllocGroupsToDb(_claimAllocationGroups);
            AddAllocGroupFspsToDb(_claimAllocationGroupFsps);

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository();

                // act
                var allocGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod(testFspCode, connectionInfo).Result;

                // Assert
                Assert.IsNotNull(allocGroupFsp);
                Assert.AreEqual(testAllocationGroupCode, allocGroupFsp.ClaimReconciliationAllocationGroupCode);
                Assert.IsNotNull(allocGroupFsp.ClaimReconciliationAllocationGroup);
                TestCleanup();
            }
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
                ((DbSet<ClaimReconciliationAllocationGroupFsp>)context.ClaimReconciliationAllocationGroupFsps)
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
    }
}