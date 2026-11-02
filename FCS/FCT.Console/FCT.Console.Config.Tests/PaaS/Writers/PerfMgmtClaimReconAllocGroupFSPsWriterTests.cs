namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimReconAllocGroupFSPsWriterTests : TestBase
    {

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconAllocGroupFSPsWriter_ShouldCreateEntity()
        {
            const string groupCode = "CRAGC";
            const string fspCode = "FSP2021";

            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}'");
                
                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(groupCode, "Group Name"));
                context.SaveChanges();
            }

            var sheetType = new ClaimReconAllocGroupFSPSheetType
            {
                ClaimReconciliationAllocationGroupCode = groupCode,
                FSPCode = fspCode,
                PolicyStatus = PolicyStatus.Approved
            };

            // act
            PerfMgmtClaimReconAllocGroupFSPsWriter.WriteToPaaSDatabase(new[] { sheetType }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFsp insertedEntity = context.ClaimReconciliationAllocationGroupFsps
                    .SingleOrDefault(fsp => fsp.ClaimReconciliationAllocationGroupCode == groupCode && fsp.FspCode == fspCode);
                Assert.IsNotNull(insertedEntity, "Entity was not inserted");
            }

            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}'");
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconAllocGroupFSPsWriter_ShouldUpdateEntity()
        {
            const string originalGroupCode = "CRAGC1";
            const string updatedGroupCode = "CRAGC2";
            const string fspCode = "FSP2021";

            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{originalGroupCode}' OR ClaimReconciliationAllocationGroupCode = '{updatedGroupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{originalGroupCode}' OR ClaimReconciliationAllocationGroupCode = '{updatedGroupCode}'");

                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(originalGroupCode, "Group Name"));
                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(updatedGroupCode, "Group Name"));
                context.ClaimReconciliationAllocationGroupFsps.Add(new ClaimReconciliationAllocationGroupFsp(originalGroupCode, fspCode));
                context.SaveChanges();
            }
            
            var sheetType = new ClaimReconAllocGroupFSPSheetType
            {
                ClaimReconciliationAllocationGroupCode = updatedGroupCode,
                FSPCode = fspCode,
                PolicyStatus = PolicyStatus.Approved
            };

            // act
            PerfMgmtClaimReconAllocGroupFSPsWriter.WriteToPaaSDatabase(new[] { sheetType }, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationAllocationGroupFsp updatedEntity = context.ClaimReconciliationAllocationGroupFsps
                    .SingleOrDefault(fsp => fsp.FspCode == fspCode);
                Assert.IsNotNull(updatedEntity, "Updated entity could not be found");
                Assert.AreEqual(updatedGroupCode, updatedEntity.ClaimReconciliationAllocationGroupCode, "Entity was not updated with new group name");
            }

            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{originalGroupCode}' OR ClaimReconciliationAllocationGroupCode = '{updatedGroupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{originalGroupCode}' OR ClaimReconciliationAllocationGroupCode = '{updatedGroupCode}'");
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconAllocGroupFSPsWriter_ShouldDeleteEntity()
        {
            const string groupCode = "CRAGC";
            const string fspCode = "FSP2021";

            // arrange
            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}'");

                context.ClaimReconciliationAllocationGroups.Add(new ClaimReconciliationAllocationGroup(groupCode, "Group Name"));
                context.ClaimReconciliationAllocationGroupFsps.Add(new ClaimReconciliationAllocationGroupFsp(groupCode, fspCode));
                context.SaveChanges();
            }

            var sheetType = new ClaimReconAllocGroupFSPSheetType
            {
                ClaimReconciliationAllocationGroupCode = groupCode,
                FSPCode = fspCode,
                PolicyStatus = PolicyStatus.Removed
            };

            // act
            PerfMgmtClaimReconAllocGroupFSPsWriter.WriteToPaaSDatabase(new[] { sheetType }, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedEntity = context.ClaimReconciliationAllocationGroupFsps.SingleOrDefault(fsp => fsp.FspCode == fspCode);
                Assert.IsNull(deletedEntity, "Entity was not deleted");
            }

            using (var context = new PerformanceManagementDbContext())
            {
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroupFsp WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}' OR FspCode = '{fspCode}'");
                context.ExecuteSqlCommand($"DELETE FROM PerformanceManagement.ClaimReconciliationAllocationGroup WHERE ClaimReconciliationAllocationGroupCode = '{groupCode}'");
                context.SaveChanges();
            }
        }
    }
}
