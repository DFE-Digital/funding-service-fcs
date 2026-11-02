namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;
    using UnitTests.Common;

    [TestClass]
    public class PerfMgmtClaimReconciliationDelGroupWriterTests
    {
        private const string ClaimReconciliationDeliverableGroupCodeTest = "Test_Code";
        private const string ClaimReconciliationDeliverableGroupNameTest = "Group_Name1";
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationDelGroupWriter_ShouldInsertRowWhenRowKeyNotFound_And_PolicyStatusIsApproved()
        {
            //arrange
            CleanUp();
            IEnumerable<ClaimReconciliationDelGroupsSheetType> rows = CreateRows(ClaimReconciliationDeliverableGroupCodeTest, PolicyStatus.Approved);

            // act
            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationDeliverableGroups.Find(ClaimReconciliationDeliverableGroupCodeTest);
                Assert.IsNotNull(entity);
                Assert.AreEqual(ClaimReconciliationDeliverableGroupNameTest,
                    entity.ClaimReconciliationDeliverableGroupName,
                    "The column Claim Reconciliation Deliverable Group Name is not the value expected");
                Assert.IsFalse(entity.CapClaimToProfile, "The column Cap Claim To Profile returned true when expected is false");
                Assert.IsTrue(entity.ObtainProfileFromReferenceData, "The Obtain Profile From Reference Data returned true when expected is true");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationDelGroupWriter_ShouldUpdateRowWhenRowKeyFound_And_PolicyStatusIsApproved()
        {
            //arrange
            CleanUp();
            const string claimReconciliationDeliverableGroupNameTest = "SommeTest";
            const bool capClaimToProfileTest = true;
            IEnumerable<ClaimReconciliationDelGroupsSheetType> rows = CreateRows(ClaimReconciliationDeliverableGroupCodeTest, PolicyStatus.Approved);
            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().ClaimReconciliationDeliverableGroupName = claimReconciliationDeliverableGroupNameTest;
            rows.First().CapClaimToProfile = capClaimToProfileTest;
            rows.First().ObtainProfileFromReferenceData = false;
            // act
            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationDeliverableGroups.Find(ClaimReconciliationDeliverableGroupCodeTest);
                Assert.AreEqual(claimReconciliationDeliverableGroupNameTest, entity.ClaimReconciliationDeliverableGroupName, "The name column has not been updated");
                Assert.AreEqual(capClaimToProfileTest, entity.CapClaimToProfile, "The CapClaimToProfile column has not been updated");
                Assert.IsFalse(entity.ObtainProfileFromReferenceData, "The ObtainProfileFromReferenceData column has not been updated");
            }
            CleanUp();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationDelGroupWriter_ShouldDeleteRowWhenRowKeyFound_And_PolicyStatusIsDeleted()
        {
            //arrange
            CleanUp();
            IEnumerable<ClaimReconciliationDelGroupsSheetType> rows = CreateRows(ClaimReconciliationDeliverableGroupCodeTest, PolicyStatus.Approved);
            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;
            
            // act
            PerfMgmtClaimReconciliationDelGroupWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationDeliverableGroups.Find(ClaimReconciliationDeliverableGroupCodeTest);
                Assert.AreEqual(null, entity);
            }
        }

        private IEnumerable<ClaimReconciliationDelGroupsSheetType> CreateRows(string code, PolicyStatus policyStatus)
        {
            return new List<ClaimReconciliationDelGroupsSheetType>
            {
                new ClaimReconciliationDelGroupsSheetType
                {
                    PolicyStatus = policyStatus,
                    ClaimReconciliationDeliverableGroupCode = code,
                    ClaimReconciliationDeliverableGroupName = ClaimReconciliationDeliverableGroupNameTest,
                    CapClaimToProfile = false,
                    ObtainProfileFromReferenceData = true
                }
            };
        }

        private void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationDeliverableGroups.RemoveWhere(crdg =>
                    crdg.ClaimReconciliationDeliverableGroupCode == ClaimReconciliationDeliverableGroupCodeTest);
                context.SaveChanges();
            }
        }
    }
}
