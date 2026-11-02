namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;

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
                ccb.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest).ToList()
                    .ForEach(crb => context.ClaimReconciliationBehaviours.Remove(crb));
                context.ClaimCollections.Where(cc => cc.ClaimCollectionCode == ClaimCollectionCodeTest).ToList()
                    .ForEach(cc => context.ClaimCollections.Remove(cc));
                context.ClaimReconciliationAllocationGroups.Where(g => g.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest).ToList()
                    .ForEach(g => context.ClaimReconciliationAllocationGroups.Remove(g));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_Find_ShouldReturnClaimReconciliationBehaviour()
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
                ConnectionInfo connectionInfo = new ConnectionInfo(context.Database.CurrentTransaction?.UnderlyingTransaction, context.Database.Connection);

                var repository = new ClaimReconciliationBehaviourRepository();

                entity = repository.Find(ClaimCollectionCodeTest, ClaimReconciliationAllocationGroupCodeTest, connectionInfo).Result;
            }

            // assert
            Assert.IsNotNull(entity);
        }
    }
}