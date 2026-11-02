namespace PerformanceManagement.DataStore.Tests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class FspDeliverableClaimRepositoryTests
    {
        private const string FspCodeToTest = "FspCode";
        private const string DelGroupCodeToTest = "DelGroup";
        private const string DelGroupNameToTest = "Name";

        // Ensure no duplicate key error occurs
        [TestInitialize]
        public void Initialize()
        {
            Cleanup();
        }

        [TestCleanup]
        public void Cleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var delsToDelete = context.FspDeliverableClaims.Where(dc => dc.FspCode == FspCodeToTest).ToList();
                var delGroupsToDelete =
                    context.ClaimReconciliationDeliverableGroups.Where(
                        dg => dg.ClaimReconciliationDeliverableGroupCode == DelGroupCodeToTest).ToList();

                delsToDelete.ForEach(dtd => context.FspDeliverableClaims.Remove(dtd));
                delGroupsToDelete.ForEach(dgtd => context.ClaimReconciliationDeliverableGroups.Remove(dgtd));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FspDeliverableClaimRepository_GetFspDeliverablesIncludingClaimDeliverableGroup_OnlyReturnsDelsForFsp_WhereClaimDeliverableGroupIsSet()
        {
            // Arrange
            var fspDelClaimRepo = new FspDeliverableClaimRepository(new PerformanceManagementDbContext());

            CreateTestFspDels();

            // Act
            var fspDels = fspDelClaimRepo.GetFspDeliverablesIncludingClaimDeliverableGroup(FspCodeToTest);

            // Assert
            Assert.AreEqual(2, fspDels.Count);
        }

        private void CreateTestFspDels()
        {
            List<FspDeliverableClaim> dels = new List<FspDeliverableClaim>
            {
                new FspDeliverableClaim(FspCodeToTest, 1, "Deliverable 1", allowClaim:false, claimReconciliationDeliverableGroupCode:null),
                new FspDeliverableClaim(FspCodeToTest, 2, "Deliverable 2", allowClaim:true, claimReconciliationDeliverableGroupCode:DelGroupCodeToTest)
                {
                    ClaimReconciliationDeliverableGroup = new ClaimReconciliationDeliverableGroup(DelGroupCodeToTest, DelGroupNameToTest, false, false)
                },
                new FspDeliverableClaim(FspCodeToTest, 3, "Deliverable 3", allowClaim:true, claimReconciliationDeliverableGroupCode:DelGroupCodeToTest),
            };

            using (var context = new PerformanceManagementDbContext())
            {
                dels.ForEach(d => context.FspDeliverableClaims.Add(d));

                context.SaveChanges();
            }
        }
    }
}
