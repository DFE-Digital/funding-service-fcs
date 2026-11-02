namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimReconciliationReferenceDataProfileWriterTests
    {
        private const string ClaimReconciliationDeliverableGroupCodeTest = "Test_Code_Writer_Test";
        private const int UkprnTest = 11223344;
        private const decimal PlannedValueTest = 555.00m;

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataProfiles.Find(ClaimReconciliationDeliverableGroupCodeTest, UkprnTest);
                if (entity != null)
                {
                    context.ClaimReconciliationReferenceDataProfiles.Remove(entity);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationReferenceDataProfileWriter_ShouldInsertRowWhenRowKeyNotFoundAndPolicyStatusIsApproved()
        {
            //arrange
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> rows = CreateRows(PolicyStatus.Approved, ClaimReconciliationDeliverableGroupCodeTest,
                                                                                                    UkprnTest, PlannedValueTest).ToList();

            // act
            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataProfiles.Find(ClaimReconciliationDeliverableGroupCodeTest, UkprnTest);
                Assert.IsNotNull(entity);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationReferenceDataProfileWriter_ShouldUpdateRowWhenRowKeyFoundAndPolicyStatusIsApproved()
        {
            //arrange
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> rows = CreateRows(PolicyStatus.Approved, ClaimReconciliationDeliverableGroupCodeTest,
                                                                                                    UkprnTest, PlannedValueTest).ToList();

            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().ClaimReconciliationDeliverableGroupCode = ClaimReconciliationDeliverableGroupCodeTest;
            rows.First().Ukprn = UkprnTest;
            rows.First().PlannedValue = PlannedValueTest+1;

            // act
            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataProfiles.Find(ClaimReconciliationDeliverableGroupCodeTest, UkprnTest);
                Assert.AreEqual(PlannedValueTest+1, entity.PlannedValue, "The updated PlannedValue is not correct");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationReferenceDataProfileWriter_ShouldDeleteRowWhenRowKeyFoundAndPolicyStatusIsDeleted()
        {
            //arrange
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> rows = CreateRows(PolicyStatus.Approved, ClaimReconciliationDeliverableGroupCodeTest,
                                                                                                    UkprnTest, PlannedValueTest).ToList();

            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);
            rows.First().PolicyStatus = PolicyStatus.Removed;

            // act
            PerfMgmtClaimReconciliationReferenceDataProfileWriter.WriteToPaaSDatabase(rows, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataProfiles.Find(ClaimReconciliationDeliverableGroupCodeTest, UkprnTest);
                Assert.IsNull(entity);
            }
        }

        private static IEnumerable<ClaimReconciliationReferenceDataProfileSheetType> CreateRows(PolicyStatus policyStatus, string code, int ukprn, decimal plannedValue)
        {
            return new List<ClaimReconciliationReferenceDataProfileSheetType>
            {
                new ClaimReconciliationReferenceDataProfileSheetType
                {
                    PolicyStatus = policyStatus,
                    ClaimReconciliationDeliverableGroupCode = code,
                    Ukprn = ukprn,
                    PlannedValue = plannedValue
                }
            };
        }
    }
}
