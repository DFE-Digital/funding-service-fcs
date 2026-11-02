namespace PerformanceManagementDomain.Tests.PullFundingClaim
{
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    [TestClass]
    public class ClaimReconciliationAllocationGroupFspRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupFspRepository_ShouldGetFspCodes()
        {
            // arrange
            ClearTable();
            AddRow("fsp1", "gc");
            AddRow("fsp2", "gc");
            AddRow("fsp3", "gc");
            
            using (var context = new PerformanceManagementDbContext())
            {
                // act
                var fspCodes = new ClaimReconciliationAllocationGroupFspRepository()
                    .GetValidFundingStreamPeriodCodes(ConnectionInfo.CreateFrom(context.Database.Connection)).Result;

                // assert
                Assert.AreEqual(3, fspCodes.Count, "The number returned is incorrect");
            }
        }

        private static void ClearTable()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationAllocationGroupFsps.ToList()
                    .ForEach(f => context.ClaimReconciliationAllocationGroupFsps.Remove(f));

                context.SaveChanges();
            }
        }

        private static void AddRow(string fsp, string groupCode)
        {
            AddFspIfNotPresent(fsp);
            AddGroupIfNotPresent(groupCode);
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationAllocationGroupFsps.Add(
                    new ClaimReconciliationAllocationGroupFsp(claimReconciliationAllocationGroupCode: groupCode,
                        fspCode: fsp));

                context.SaveChanges();
            }
        }

        private static void AddFspIfNotPresent(string fspCode)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                if (!context.FundingStreamPeriods.Any(fsp => fsp.FundingStreamPeriodCode == fspCode))
                {
                    context.FundingStreamPeriods.Add(new FundingStreamPeriod(fspCode, false));
                }

                context.SaveChanges();
            }
        }

        private static void AddGroupIfNotPresent(string groupCode)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                if (!context.ClaimReconciliationAllocationGroups.Any(g => g.ClaimReconciliationAllocationGroupCode == groupCode))
                {
                    context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(groupCode, groupCode));
                }

                context.SaveChanges();
            }
        }
    }
}
