namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class CdaExtractFspWriterTests
    {
        private const string TestExtractName = "TEST EXTRACT NAME - FspWriterTests";
        private static readonly string[] TestFspCodes = {"TestCode1", "TestCode2"};

        [TestInitialize]
        public void Startup()
        {
            Cleanup();
        }

        [TestCleanup]
        public void Cleanup()
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CdaReportFundingStreamPeriods
                    .Where(r => r.ExtractName == TestExtractName)
                    .ForEach(ti => context.CdaReportFundingStreamPeriods.Remove(ti));

                context.CdaExtracts
                    .Where(r => r.ExtractName == TestExtractName)
                    .ForEach(ti => context.CdaExtracts.Remove(ti));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspWriter_NewItems_ShouldCreateNewEntriesInPaas()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.CdaExtracts.Add(new CdaExtract(TestExtractName));
                context.SaveChanges();
            }

            IReadOnlyCollection<CdaExtractFspSheetType> sheetTypes =
                TestFspCodes.Select(
                    c =>
                        new CdaExtractFspSheetType
                        {
                            ExtractName = TestExtractName,
                            FundingStreamPeriodCode = c,
                            PolicyStatus = PolicyStatus.Approved
                        }).ToList();

            IReadOnlyCollection<CdaReportFundingStreamPeriod> expected =
                TestFspCodes.Select(c => new CdaReportFundingStreamPeriod(TestExtractName, c)).ToList();

            // act
            CdaExtractFspWriter.WriteToPaaSDatabase(sheetTypes, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                IReadOnlyCollection<CdaReportFundingStreamPeriod> actual =
                    context.CdaReportFundingStreamPeriods.Where(r => r.ExtractName == TestExtractName).ToList();

                Assert.AreEqual(2, actual.Count, "The wrong number of entries were created");
                expected.ForEach(
                    e =>
                        Assert.IsTrue(
                            actual.Any(
                                a =>
                                    a.ExtractName == e.ExtractName && a.FundingStreamPeriodCode == e.FundingStreamPeriodCode),
                            $"Expected Extract {e.ExtractName} FSP {e.FundingStreamPeriodCode} was not found in results"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspWriter_RemovedItems_ShouldRemoveEntriesInPaas()
        {
            // arrange
            using (var context = new ContractManagementDbContext())
            {
                context.CdaExtracts.Add(new CdaExtract(TestExtractName));

                TestFspCodes.ForEach(
                    c => context.CdaReportFundingStreamPeriods.Add(new CdaReportFundingStreamPeriod(TestExtractName, c)));

                context.SaveChanges();
            }

            IReadOnlyCollection<CdaExtractFspSheetType> sheetTypes =
                TestFspCodes.Select(
                    c =>
                        new CdaExtractFspSheetType
                        {
                            ExtractName = TestExtractName,
                            FundingStreamPeriodCode = c,
                            PolicyStatus = PolicyStatus.Removed
                        }).ToList();

            // act
            CdaExtractFspWriter.WriteToPaaSDatabase(sheetTypes, WriterBehaviour.Delete);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                IEnumerable<CdaReportFundingStreamPeriod> actual =
                    context.CdaReportFundingStreamPeriods.Where(r => r.ExtractName == TestExtractName);

                Assert.IsFalse(actual.Any(), $"{actual.Count()} entires were not removed.");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspWriter_DraftItems_ShouldNotBeCreatedInPaas()
        {
            // arrange
            IReadOnlyCollection<CdaExtractFspSheetType> sheetTypes =
                TestFspCodes.Select(
                    c =>
                        new CdaExtractFspSheetType
                        {
                            ExtractName = TestExtractName,
                            FundingStreamPeriodCode = c,
                            PolicyStatus = PolicyStatus.Draft
                        }).ToList();

            // act
            CdaExtractFspWriter.WriteToPaaSDatabase(sheetTypes, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new ContractManagementDbContext())
            {
                IEnumerable<CdaReportFundingStreamPeriod> actual =
                    context.CdaReportFundingStreamPeriods.Where(r => r.ExtractName == TestExtractName);

                Assert.IsFalse(actual.Any(), $"{actual.Count()} entires were erroneously added.");
            }
        }
    }
}