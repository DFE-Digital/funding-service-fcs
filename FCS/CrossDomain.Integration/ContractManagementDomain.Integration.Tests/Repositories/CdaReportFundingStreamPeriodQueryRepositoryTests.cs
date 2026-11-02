namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class CdaReportFundingStreamPeriodQueryRepositoryTests
    {
        private IContractManagementDbContext _context;
        private const string TestExtractName = "TestExtract";
        private const string OutOfDateExtractName = "TestExtract2";
        private static readonly IReadOnlyCollection<string> TestFsps = new List<string> {"TestFsp1", "TestFsp2"};
        private static readonly IReadOnlyCollection<string> OutOfDateFsps = new List<string> { "TestFsp3", "TestFsp4" };

        [TestInitialize]
        public void Setup()
        {
            _context = new ContractManagementDbContext();

            Cleanup();

            TestFsps.ForEach(
                fsp =>
                    _context.CdaReportFundingStreamPeriods.Add(new CdaReportFundingStreamPeriod(TestExtractName, fsp)));

            OutOfDateFsps.ForEach(fsp =>
                    _context.CdaReportFundingStreamPeriods.Add(new CdaReportFundingStreamPeriod(OutOfDateExtractName, fsp)));

            _context.CdaExtracts.Add(new CdaExtract(OutOfDateExtractName)
            {
                ReportingCloseDate = new DateTime(2017, 1, 1)
            });

            _context.CdaExtracts.Add(new CdaExtract(TestExtractName)
            {
                ReportingCloseDate = new DateTime(2017, 2, 1)
            });

            _context.SaveChanges();
        }

        [TestCleanup]
        public void Cleanup()
        {
            var testRecords =
                _context.CdaReportFundingStreamPeriods.Where(
                    cda => cda.ExtractName == TestExtractName || cda.ExtractName == OutOfDateExtractName);

            var cdaExtractTestRecords =
                _context.CdaExtracts.Where(
                    e => e.ExtractName == OutOfDateExtractName || e.ExtractName == TestExtractName);

            testRecords.ForEach(tr => _context.CdaReportFundingStreamPeriods.Remove(tr));

            cdaExtractTestRecords.ForEach(etr => _context.CdaExtracts.Remove(etr));

            _context.SaveChanges();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaReportFundingStreamPeriodQueryRepository_GetAllWithinPublicationDate_ShouldFilterOutReportsWherePublicationDateIsPast()
        {
            // arrange
            var repository = new CdaReportFundingStreamPeriodQueryRepository(_context);

            // act
            var reports = repository.GetAllWithinPublicationCloseDate(new DateTime(2017, 1, 2));

            // assert
            Assert.IsNull(reports.SingleOrDefault(r => r.Description == OutOfDateExtractName));
            Assert.IsNotNull(reports.SingleOrDefault(r => r.Description == TestExtractName));
            Assert.AreEqual(2, reports.Single(r => r.Description == TestExtractName).ReportFspCodes.Count, "The wrong number of FSP codes were returned");
            TestFsps.ForEach(
                tf =>
                    Assert.IsTrue(reports.Any(r => r.ReportFspCodes.Contains(tf)),
                        $"The repository did not return a record for FSP {tf}"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaReportFundingStreamPeriodQueryRepository_GetAllWithinPublicationDate_ShouldNotFilterOutReportsWherePublicationDateIsInTheFuture()
        {
            // arrange
            var repository = new CdaReportFundingStreamPeriodQueryRepository(_context);

            // act
            var reports = repository.GetAllWithinPublicationCloseDate(new DateTime(2016, 1, 1, 12, 56, 45));

            // assert
            Assert.IsNotNull(reports.SingleOrDefault(r => r.Description == OutOfDateExtractName));
            Assert.IsNotNull(reports.SingleOrDefault(r => r.Description == TestExtractName));
            Assert.AreEqual(4,
                reports.Where(r => r.Description == TestExtractName || r.Description == OutOfDateExtractName)
                       .SelectMany(r => r.ReportFspCodes)
                       .ToList()
                       .Count, "The wrong number of FSP codes were returned");
            TestFsps.ForEach(
                tf =>
                    Assert.IsTrue(reports.Any(r => r.ReportFspCodes.Contains(tf)),
                        $"The repository did not return a record for FSP {tf}"));
            OutOfDateFsps.ForEach(
                tf =>
                    Assert.IsTrue(reports.Any(r => r.ReportFspCodes.Contains(tf)),
                        $"The repository did not return a record for FSP {tf}"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaReportFundingStreamPeriodQueryRepository_GetAllWithinPublicationDate_ShouldNotFilterOutReportsWherePublicationDateIsToday()
        {
            // arrange
            var repository = new CdaReportFundingStreamPeriodQueryRepository(_context);

            // act
            var reports = repository.GetAllWithinPublicationCloseDate(new DateTime(2017, 1, 1, 12, 56, 45));

            // assert
            Assert.IsNotNull(reports.SingleOrDefault(r => r.Description == OutOfDateExtractName));
            Assert.IsNotNull(reports.SingleOrDefault(r => r.Description == TestExtractName));
            Assert.AreEqual(4,
                reports.Where(r => r.Description == TestExtractName || r.Description == OutOfDateExtractName)
                       .SelectMany(r => r.ReportFspCodes)
                       .ToList()
                       .Count, "The wrong number of FSP codes were returned");
            TestFsps.ForEach(
                tf =>
                    Assert.IsTrue(reports.Any(r => r.ReportFspCodes.Contains(tf)),
                        $"The repository did not return a record for FSP {tf}"));
            OutOfDateFsps.ForEach(
                tf =>
                    Assert.IsTrue(reports.Any(r => r.ReportFspCodes.Contains(tf)),
                        $"The repository did not return a record for FSP {tf}"));
        }
    }
}