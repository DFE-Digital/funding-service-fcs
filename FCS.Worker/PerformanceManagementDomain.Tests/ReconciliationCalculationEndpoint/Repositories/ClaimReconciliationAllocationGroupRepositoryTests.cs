namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using UnitTests.Common;

    [TestClass]
    public class ClaimReconciliationAllocationGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupRepository_Find_ShouldGetAllocationGroup()
        {
            // arrange
            const string allocationGroupCode = "AllocationGroupCodeFind";
            const string allocationGroupName = "Tests ClaimReconciliationAllocationGroupRepository Find";
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationAllocationGroups.RemoveWhere(crag =>
                    crag.ClaimReconciliationAllocationGroupCode == allocationGroupCode);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                var claimReconciliationAllocationGroup = new ClaimReconciliationAllocationGroup(allocationGroupCode, allocationGroupName);

                context.ClaimReconciliationAllocationGroups.Add(claimReconciliationAllocationGroup);
                context.SaveChanges();
            }

            using (var context = new PerformanceManagementDbContext())
            {
                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);
                var claimReconciliationAllocationGroupRepository = new ClaimReconciliationAllocationGroupRepository();

                 // act
                 var claimReconciliationAllocationGroupAssert = claimReconciliationAllocationGroupRepository.Find(allocationGroupCode, connectionInfo).Result;

                // assert
                Assert.IsNotNull(claimReconciliationAllocationGroupAssert, "Unexpected null result returned");
                Assert.AreEqual(allocationGroupName, claimReconciliationAllocationGroupAssert.GroupName, "Unexpected group name returned");
            }
        }
    }
}