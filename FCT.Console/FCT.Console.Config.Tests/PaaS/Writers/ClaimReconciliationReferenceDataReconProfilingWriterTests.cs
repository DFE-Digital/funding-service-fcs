namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class ClaimReconciliationReferenceDataReconProfilingWriterTests
    {
        private const string FundingPeriod1 = "AY2021";
        private const string FundingPeriod2 = "AY2122";
        private const int TestUkprn1 = 11111111;
        private const int TestUkprn2 = 22222222;

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingWriter_ShouldInsertRowWhenPolicyStatusIsApproved()
        {
            // arrange
            Cleanup();

            ClaimReconciliationReferenceDataReconProfilingSheetType[] rows =
            {
                new ClaimReconciliationReferenceDataReconProfilingSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    FundingPeriod = FundingPeriod1,
                    Ukprn = TestUkprn1
                }
            };

            // act
            ClaimReconciliationReferenceDataReconProfilingWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataReconProfilings
                    .Find(FundingPeriod1, TestUkprn1);
                Assert.IsNotNull(entity, "Approved ClaimReconciliationReferenceDataReconProfiling was not added to PAAS table");
            }
            Cleanup();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingWriter_ShouldNotInsertRowWhenPolicyStatusIsDraft()
        {
            // arrange
            Cleanup();

            ClaimReconciliationReferenceDataReconProfilingSheetType[] rows =
            {
                new ClaimReconciliationReferenceDataReconProfilingSheetType
                {
                    PolicyStatus = PolicyStatus.Draft,
                    FundingPeriod = FundingPeriod1,
                    Ukprn = TestUkprn1
                }
            };

            // act
            ClaimReconciliationReferenceDataReconProfilingWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                var entity = context.ClaimReconciliationReferenceDataReconProfilings
                    .Find(FundingPeriod1, TestUkprn1);
                Assert.IsNull(entity, "Draft ClaimReconciliationReferenceDataReconProfiling was incorrectly added to PAAS table");
            }
            Cleanup();
        }

        private static void Cleanup()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                string deleteSqlCommand = "DELETE FROM [PerformanceManagement].[ClaimReconciliationPublicationException] "
                                                   + $" WHERE [UKPRN] IN ({TestUkprn1}, {TestUkprn2})";

                context.ExecuteSqlCommand(deleteSqlCommand);
            }
        }
    }
}