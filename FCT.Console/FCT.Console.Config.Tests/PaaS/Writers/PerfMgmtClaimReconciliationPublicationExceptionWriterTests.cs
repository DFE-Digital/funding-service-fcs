namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtClaimReconciliationPublicationExceptionWriterTests
    {
        private const string TestClaimReconciliationAllocationGroup1New = "AEBC1718";
        private const string TestClaimReconciliationAllocationGroup2New = "AEBC1718";
        private const string TestClaimReconciliationAllocationGroup3Old = "ALLBC1718";
        private const string TestClaimReconciliationAllocationGroup4Old = "AEB-LS1718";
        private const int TestUkprn1New = 11111111;
        private const int TestUkprn2New = 22222222;
        private const int TestUkprn3Old = 33333333;
        private const int TestUkprn4Old = 44444444;

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationPublicationExceptionWriter_ShouldInsertRowWhenPolicyStatusIsApproved()
        {
            // arrange
            Cleanup();

            ClaimReconciliationPublicationExceptionSheetType[] rows =
            {
                new ClaimReconciliationPublicationExceptionSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    ClaimReconciliationAllocationGroupCode = TestClaimReconciliationAllocationGroup1New,
                    Ukprn = TestUkprn1New
                }
            };

            // act
            PerfMgmtClaimReconciliationPublicationExceptionWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationException entity = context.ClaimReconciliationPublicationExceptions
                    .Find(TestClaimReconciliationAllocationGroup1New, TestUkprn1New);
                Assert.IsNotNull(entity, "Approved ClaimReconciliationPublicationException was not added to PAAS table");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationPublicationExceptionWriter_ShouldNotInsertRowWhenPolicyStatusIsDraft()
        {
            // arrange
            Cleanup();

            ClaimReconciliationPublicationExceptionSheetType[] rows =
            {
                new ClaimReconciliationPublicationExceptionSheetType
                {
                    PolicyStatus = PolicyStatus.Draft,
                    ClaimReconciliationAllocationGroupCode = TestClaimReconciliationAllocationGroup1New,
                    Ukprn = TestUkprn1New
                }
            };

            // act
            PerfMgmtClaimReconciliationPublicationExceptionWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationException entity = context.ClaimReconciliationPublicationExceptions
                    .Find(TestClaimReconciliationAllocationGroup1New, TestUkprn1New);
                Assert.IsNull(entity, "Draft ClaimReconciliationPublicationException was incorrectly added to PAAS table");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtClaimReconciliationPublicationExceptionWriter_ShouldReplaceExistingRows()
        {
            // arrange
            Cleanup();
            CreateAndPersistOldClaimReconciliationPublicationExceptions();

            ClaimReconciliationPublicationExceptionSheetType[] rows =
            {
                new ClaimReconciliationPublicationExceptionSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    ClaimReconciliationAllocationGroupCode = TestClaimReconciliationAllocationGroup1New,
                    Ukprn = TestUkprn1New
                },
                new ClaimReconciliationPublicationExceptionSheetType
                {
                    PolicyStatus = PolicyStatus.Approved,
                    ClaimReconciliationAllocationGroupCode = TestClaimReconciliationAllocationGroup2New,
                    Ukprn = TestUkprn2New
                }
            };

            // act
            PerfMgmtClaimReconciliationPublicationExceptionWriter.WriteToPaaSDatabase(rows, WriterBehaviour.AddOrUpdate);

            // assert
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                ClaimReconciliationPublicationException entity1 = context.ClaimReconciliationPublicationExceptions
                    .Find(TestClaimReconciliationAllocationGroup1New, TestUkprn1New);
                Assert.IsNotNull(entity1, "Approved ClaimReconciliationPublicationException was not added to PAAS table");

                ClaimReconciliationPublicationException entity3 = context.ClaimReconciliationPublicationExceptions
                    .Find(TestClaimReconciliationAllocationGroup3Old, TestUkprn3Old);
                Assert.IsNull(entity3, "ClaimReconciliationPublicationException was not replaced in PAAS table");
            }
        }

        private static void Cleanup()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                string deleteExceptionSqlCommand = "DELETE FROM [PerformanceManagement].[ClaimReconciliationPublicationException] "
                                                   + $" WHERE [UKPRN] IN ({TestUkprn1New}, {TestUkprn2New}, {TestUkprn3Old}, {TestUkprn4Old})";

                context.ExecuteSqlCommand(deleteExceptionSqlCommand);
            }
        }

        private static void CreateAndPersistOldClaimReconciliationPublicationExceptions()
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationPublicationExceptions
                    .Add(new ClaimReconciliationPublicationException(TestClaimReconciliationAllocationGroup3Old, TestUkprn3Old));
                context.ClaimReconciliationPublicationExceptions
                    .Add(new ClaimReconciliationPublicationException(TestClaimReconciliationAllocationGroup4Old, TestUkprn4Old));
                context.SaveChanges();
            }
        }
    }
}
