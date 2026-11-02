namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimReconciliationAllocationGroupWriterTests : TestBase
    {
        private const string ClaimReconciliationAllocationGroupCodeToInsert = "CodeToInsert";
        private const string GroupNameToInsert = "GroupNameToInsert";

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var claimReconAllocGroupsToRemove = new List<ClaimReconciliationAllocationGroup>
                {
                    context.ClaimReconciliationAllocationGroups.Find(ClaimReconciliationAllocationGroupCodeToInsert)
                };

                foreach (var allocationGroup in claimReconAllocGroupsToRemove.Where(ag => ag != null))
                {
                    context.ClaimReconciliationAllocationGroups.Remove(allocationGroup);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewClaimReconAllocGroup_NewClaimReconAllocGroup_IsInserted_InPaasTable()
        {
            //arrange
            List<ClaimReconciliationAllocationGroupSheetType> testClaimTypes = CreateApprovedTestEntities();

            // act
            PerfMgmtClaimReconciliationAllocationGroupWriter.WriteToPaaSDatabase(testClaimTypes, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                Assert.IsNotNull(context.ClaimReconciliationAllocationGroups.Find(ClaimReconciliationAllocationGroupCodeToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedClaimType_ExistingClaimType_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = "UpdatedNameToInsert";

            //Setup data
            using (var context = new PerformanceManagementDbContext())
            {
                var originalTestClaimAllocationGroups = CreateApprovedTestEntities();
                originalTestClaimAllocationGroups.ForEach(ag =>
                {
                    context.ClaimReconciliationAllocationGroups.Add(TypeTransformer.Transform<ClaimReconciliationAllocationGroupSheetType, ClaimReconciliationAllocationGroup>(ag));
                });
                
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestClaimAllocationGroups = CreateApprovedTestEntities();
            newTestClaimAllocationGroups[0].GroupName = updatedValue;

            // act
            PerfMgmtClaimReconciliationAllocationGroupWriter.WriteToPaaSDatabase(newTestClaimAllocationGroups, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var updatedRecord = context.ClaimReconciliationAllocationGroups.Find(ClaimReconciliationAllocationGroupCodeToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.GroupName);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aClaimTypeToBeDeleted_TheClaimType_IsDeleted_InPaasTable()
        {
            // arrange
            var testClaimReconAllocationGroups = CreateTestEntitiesToDelete();

            //Setup data to delete
            using (var context = new PerformanceManagementDbContext())
            {
                testClaimReconAllocationGroups.ForEach(allocationGroup =>
                {
                    context.ClaimReconciliationAllocationGroups.Add(
                        TypeTransformer.Transform<ClaimReconciliationAllocationGroupSheetType, ClaimReconciliationAllocationGroup>(allocationGroup));
                });
                
                context.SaveChanges();
            }

            // act
            PerfMgmtClaimReconciliationAllocationGroupWriter.WriteToPaaSDatabase(testClaimReconAllocationGroups, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedRecord = context.ClaimReconciliationAllocationGroups.Find(ClaimReconciliationAllocationGroupCodeToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<ClaimReconciliationAllocationGroupSheetType> CreateTestEntitiesToDelete()
        {
            return new List<ClaimReconciliationAllocationGroupSheetType>
            {
                new ClaimReconciliationAllocationGroupSheetType
                {
                    ClaimReconciliationAllocationGroupCode = ClaimReconciliationAllocationGroupCodeToInsert,
                    GroupName = GroupNameToInsert,
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<ClaimReconciliationAllocationGroupSheetType> CreateApprovedTestEntities()
        {
            // arrange
            return new List<ClaimReconciliationAllocationGroupSheetType>
            {
                new ClaimReconciliationAllocationGroupSheetType
                {
                    ClaimReconciliationAllocationGroupCode = ClaimReconciliationAllocationGroupCodeToInsert,
                    GroupName = GroupNameToInsert,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
