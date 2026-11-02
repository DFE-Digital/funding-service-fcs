namespace PerformanceManagement.DataStore.Tests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class ClaimReconciliationBehaviourRepositoryTests
    {
        private const string ClaimCollectionCodeTest = "Some CC";
        private const string ClaimReconciliationAllocationGroupCodeTest = "Some GC";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationBehaviours.Where(ccb => ccb.ClaimCollectionCode == ClaimCollectionCodeTest &&
                ccb.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest)
                    .ForEach(crb => context.ClaimReconciliationBehaviours.Remove(crb));
                context.ClaimCollections.Where(cc => cc.ClaimCollectionCode == ClaimCollectionCodeTest)
                    .ForEach(cc => context.ClaimCollections.Remove(cc));
                context.ClaimReconciliationAllocationGroups.Where(g => g.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest)
                    .ForEach(g => context.ClaimReconciliationAllocationGroups.Remove(g));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_ShouldAddEntityToTable()
        {
            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimCollections.Add(new ClaimCollection(ClaimCollectionCodeTest, "F", "1516", "AY"));
                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(ClaimReconciliationAllocationGroupCodeTest, "Desc"));
                context.ClaimReconciliationBehaviours.Add(new ClaimReconciliationBehaviour(ClaimCollectionCodeTest,
                    ClaimReconciliationAllocationGroupCodeTest, true, true, true, 10M, 10M, null, 0, 0, UnderDeliveryRecoveryAmount.Full));
                context.SaveChanges();
            }

            ClaimReconciliationBehaviour entity = null;
            // act 
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository(context);
                entity = repository.Find(ClaimCollectionCodeTest, ClaimReconciliationAllocationGroupCodeTest);
            }

            // assert
            Assert.IsNotNull(entity);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_DoesClaimCollectionCodeExist_ShouldReturnTrue_WhenCollectionCodeExistsInTable()
        {
            // arrange
            string claimCollectionCode = "1516-FINAL";

            // act 
            bool isCollectionCodePresent;
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository(context);
                isCollectionCodePresent = repository.DoesClaimCollectionCodeExist(claimCollectionCode);
            }

            // assert
            Assert.IsTrue(isCollectionCodePresent);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_DoesClaimCollectionCodeExist_ShouldReturnFalse_WhenCollectionCodeDoesNotExistsnTable()
        {
            // arrange
            string claimCollectionCode = "1516-Final";

            // act 
            bool isCollectionCodePresent;
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository(context);
                isCollectionCodePresent = repository.DoesClaimCollectionCodeExist(claimCollectionCode);
            }

            // assert
            Assert.IsTrue(isCollectionCodePresent);
        }
    }
}
