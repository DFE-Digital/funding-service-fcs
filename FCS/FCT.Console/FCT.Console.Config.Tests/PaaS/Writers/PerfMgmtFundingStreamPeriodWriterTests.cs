namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtFundingStreamPeriodWriterTests
    {
        private const string TestFspCodePrefix = "TESTPM";

        [TestCleanup]
        public void Cleanup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var fspsToRemove = context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode.StartsWith(TestFspCodePrefix));

                fspsToRemove.ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtFundingStreamPeriodWriter_Should_AddNewFspIfNotExistsAndPolicyStatusIsApproved()
        {
            // arrange
            Cleanup();
            var fspsToAdd = GetFspSheetTypes();

            // act
            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspsToAdd, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var addedFsps =
                    context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode.StartsWith(TestFspCodePrefix))
                           .ToList();

                Assert.AreEqual(3, addedFsps.Count);
                Assert.AreEqual(1, addedFsps.Count(fsp => fsp.IsPayOnProfile));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtFundingStreamPeriodWriter_Should_UpdateFspIfAlreadyExistsAndPolicyStatusIsApproved()
        {
            // arrange
            Cleanup();
            var fspsToAdd = GetFspSheetTypes();

            // act
            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspsToAdd, WriterBehaviour.AddOrUpdate);

            fspsToAdd[1].PaymentMethod = "Pay on Profile";

            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspsToAdd, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var addedFsps =
                    context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode.StartsWith(TestFspCodePrefix))
                           .ToList();

                Assert.AreEqual(2, addedFsps.Count(fsp => fsp.IsPayOnProfile));
                Assert.AreEqual(1, addedFsps.Count(fsp => !fsp.IsPayOnProfile));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PerfMgmtFundingStreamPeriodWriter_Should_DeleteFspIfAlreadyExistsAndPolicyStatusIsRemoved()
        {
            // arrange
            Cleanup();
            var fspsToAdd = GetFspSheetTypes();

            // act
            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspsToAdd, WriterBehaviour.AddOrUpdate);

            fspsToAdd[0].PolicyStatus = PolicyStatus.Removed;

            PerfMgmtFundingStreamPeriodWriter.WriteToPaaSDatabase(fspsToAdd, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var addedFsps =
                    context.FundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriodCode.StartsWith(TestFspCodePrefix))
                           .ToList();

                Assert.AreEqual(0, addedFsps.Count(fsp => fsp.IsPayOnProfile));
                Assert.AreEqual(2, addedFsps.Count);
            }
        }

        private List<FundingStreamPeriodSheetType> GetFspSheetTypes()
        {
            return new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{TestFspCodePrefix}1",
                    PaymentMethod = "Pay on Profile",
                    PolicyStatus = PolicyStatus.Approved
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{TestFspCodePrefix}2",
                    PaymentMethod = "Pay on Actuals",
                    PolicyStatus = PolicyStatus.Approved
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{TestFspCodePrefix}3",
                    PaymentMethod = "Paid Externally",
                    PolicyStatus = PolicyStatus.Approved
                },
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = $"{TestFspCodePrefix}4",
                    PaymentMethod = "Pay on Profile",
                    PolicyStatus = PolicyStatus.Draft
                }
            };
        }
    }
}