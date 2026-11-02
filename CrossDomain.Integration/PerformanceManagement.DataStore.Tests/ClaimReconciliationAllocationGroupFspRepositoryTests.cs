namespace PerformanceManagement.DataStore.Tests
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Repositories;

    [TestClass]
    public class ClaimReconciliationAllocationGroupFspRepositoryTests
    {
        private const string ClaimReconciliationAllocationGroupTest = "SomeGroup";
        private const string FspCodeTest = "SomeFSP";

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
                    .Where(g => g.ClaimReconciliationAllocationGroupCode == ClaimReconciliationAllocationGroupTest)
                    .ForEach(g => context.ClaimReconciliationAllocationGroups.Remove(g));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_ShouldReturnNull_When_GetClaimAllocationGroupForFundingStreamPeriod_Is_CalledForNonExistingFsp()
        {
            // arrange 

            // act
            ClaimReconciliationAllocationGroupFsp claimReconciliationAllocationGroupFsp = null;
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                claimReconciliationAllocationGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod("X");
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
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                repository.AddEntity(claimReconciliationAllocationGroupFsp);
                context.SaveChanges();
            }

            // act
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                claimReconciliationAllocationGroupFsp = repository.GetClaimAllocationGroupForFundingStreamPeriod(FspCodeTest);
            }

            // assert
            Assert.IsNotNull(claimReconciliationAllocationGroupFsp);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_IsFundingStreamPeriodValid_ShouldReturnTrueForValidFsp()
        {
            // arrange 
            ClaimReconciliationAllocationGroupFsp claimReconciliationAllocationGroupFsp =
                new ClaimReconciliationAllocationGroupFsp(ClaimReconciliationAllocationGroupTest, FspCodeTest)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(ClaimReconciliationAllocationGroupTest, "Desc")
                };

            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                repository.AddEntity(claimReconciliationAllocationGroupFsp);
                context.SaveChanges();
            }

            // act
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                bool isValid = repository.IsFundingStreamPeriodValid(FspCodeTest);
                Assert.IsTrue(isValid);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_IsFundingStreamPeriodValid_ShouldReturnFalseForInValidFsp()
        {
            // arrange 
            ClaimReconciliationAllocationGroupFsp claimReconciliationAllocationGroupFsp =
                new ClaimReconciliationAllocationGroupFsp(ClaimReconciliationAllocationGroupTest, FspCodeTest)
                {
                    ClaimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(ClaimReconciliationAllocationGroupTest, "Desc")
                };

            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                repository.AddEntity(claimReconciliationAllocationGroupFsp);
                context.SaveChanges();
            }

            // act
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFspRepository repository = new ClaimReconciliationAllocationGroupFspRepository(context);

                bool isValid = repository.IsFundingStreamPeriodValid("Random FSP");
                Assert.IsFalse(isValid);
            }
        }
    }
}
