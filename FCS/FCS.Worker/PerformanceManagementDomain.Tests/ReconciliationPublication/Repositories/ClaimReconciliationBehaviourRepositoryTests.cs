namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class ClaimReconciliationBehaviourRepositoryTests
    {
        private const string ClaimCollectionCodeTest = "Some CC";
        private const string ClaimReconciliationAllocationGroupCodeTest = "Some GC";

        [TestInitialize, TestCleanup]
        public void CleanUp()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationBehaviours.Where(ccb => ccb.ClaimCollectionCode == ClaimCollectionCodeTest &&
                ccb.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest)
                    .ToList()
                    .ForEach(crb => context.ClaimReconciliationBehaviours.Remove(crb));
                context.ClaimCollections.Where(cc => cc.ClaimCollectionCode == ClaimCollectionCodeTest)
                    .ToList()
                    .ForEach(cc => context.ClaimCollections.Remove(cc));
                context.ClaimReconciliationAllocationGroups.Where(g => g.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupCodeTest)
                    .ToList()
                    .ForEach(g => context.ClaimReconciliationAllocationGroups.Remove(g));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsClaimCollectionPayable_ShouldReturnTrue_ForFinal()
        {
            // arrange
            const string allocationGroupCode = "ASC1516";
            const string claimCollectionCode = "1516-Final";

            // act 
            bool isCollectionPayable;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isCollectionPayable = repository.IsClaimCollectionPayable(connectionInfo, claimCollectionCode, allocationGroupCode).Result;
            }

            // assert
            Assert.IsTrue(isCollectionPayable);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsClaimCollectionPayable_ShouldReturnFalse_ForYearEnd()
        {
            // arrange
            const string allocationGroupCode = "ASC1516";
            const string claimCollectionCode = "1516-YearEnd";

            // act 
            bool isCollectionPayable;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isCollectionPayable = repository.IsClaimCollectionPayable(connectionInfo, claimCollectionCode, allocationGroupCode).Result;
            }

            // assert
            Assert.IsFalse(isCollectionPayable);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsAfterPublicationCloseDate_ShouldReturnFalseWhenCurrentDateIsBeforePublicationCloseDate()
        {
            // arrange
            const string allocationGroupCode = "ASC1516";
            const string claimCollectionCode = "1516-YearEnd";
            DateTime currentDate = new DateTime(2017, 07, 03, 0, 0, 0, DateTimeKind.Utc);

            // act 
            bool isAfterPublicationCloseDate;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isAfterPublicationCloseDate = repository.IsAfterPublicationCloseDate(connectionInfo, claimCollectionCode, allocationGroupCode, currentDate).Result;
            }

            // assert
            Assert.IsFalse(isAfterPublicationCloseDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsAfterPublicationCloseDate_ShouldReturnTrueWhenCurrentDateIsAfterPublicationCloseDate()
        {
            // arrange
            const string allocationGroupCode = "ASC1516";
            const string claimCollectionCode = "1516-YearEnd";
            DateTime currentDate = new DateTime(2017, 07, 05, 0, 0, 0, DateTimeKind.Utc);

            // act 
            bool isAfterPublicationCloseDate;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isAfterPublicationCloseDate = repository.IsAfterPublicationCloseDate(connectionInfo, claimCollectionCode, allocationGroupCode, currentDate).Result;
            }

            // assert
            Assert.IsTrue(isAfterPublicationCloseDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsAfterPublicationCloseDate_ShouldReturnFalseWhenCurrentDateIsDuringDayOfPublicationCloseDate()
        {
            // arrange
            const string allocationGroupCode = "ASC1516";
            const string claimCollectionCode = "1516-YearEnd";
            DateTime currentDate = new DateTime(2017, 07, 04, 11, 30, 0, DateTimeKind.Utc);

            // act 
            bool isAfterPublicationCloseDate;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isAfterPublicationCloseDate = repository.IsAfterPublicationCloseDate(connectionInfo, claimCollectionCode, allocationGroupCode, currentDate).Result;
            }

            // assert
            Assert.IsFalse(isAfterPublicationCloseDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationBehaviourRepository_IsAfterPublicationCloseDate_ShouldReturnFalseWhenPublicationCloseDateIsNull()
        {
            // arrange
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.ClaimCollections.Add(new ClaimCollection(ClaimCollectionCodeTest, "F", "1516", "AY"));
                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(ClaimReconciliationAllocationGroupCodeTest, "Desc"));
                context.ClaimReconciliationBehaviours.Add(new ClaimReconciliationBehaviour(ClaimCollectionCodeTest,
                    ClaimReconciliationAllocationGroupCodeTest, true, true, true, 10M, 10M, null, 0, 0,
                    underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full));
                context.SaveChanges();
            }

            DateTime currentDate = new DateTime(2017, 07, 04, 11, 30, 0, DateTimeKind.Utc);

            // act 
            bool isAfterPublicationCloseDate;
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationBehaviourRepository repository = new ClaimReconciliationBehaviourRepository();
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                isAfterPublicationCloseDate = repository.IsAfterPublicationCloseDate(connectionInfo, ClaimCollectionCodeTest, ClaimReconciliationAllocationGroupCodeTest, currentDate).Result;
            }

            // assert
            Assert.IsFalse(isAfterPublicationCloseDate);
        }
    }
}
