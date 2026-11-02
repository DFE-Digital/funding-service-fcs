namespace FCT.Operations.Cda.Tests.Repositories
{
    using ContractManagement.DataStore;
    using FCT.Operations.Cda.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using Moq;

    [TestClass]
    public class CdaConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaConfigRepository_GetAllCdaExtracts_ShouldRetrieveCdaExtractConfigIncludingCdaReportFundingStreamPeriods()
        {
            // arrange 
            const string testExtractName = "CdaConfigRepositoryTest";
            DateTime? testReportingCloseDate = DateTime.Now.Date.AddDays(1);
            string[] testFspCodes = { "fsp1", "fsp2" };
            int cdaExtractAssertRecordCount;
            int cdaReportFundingStreamPeriodsMainstream1718AssertRecordCount;

            ClearDownTestExtract(testExtractName);

            using (var context = new ContractManagementDbContext())
            {
                var cdaExtract = new CdaExtract(testExtractName);
                cdaExtract.ReportingCloseDate = testReportingCloseDate;

                context.CdaExtracts.Add(cdaExtract);
                context.SaveChanges();

                testFspCodes.ToList().ForEach(
                    c => context.CdaReportFundingStreamPeriods.Add(new CdaReportFundingStreamPeriod(testExtractName, c)));

                context.SaveChanges();
            }

            // get assert counts
            using (var context = new ContractManagementDbContext())
            {
                cdaExtractAssertRecordCount = context.CdaExtracts.Count(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= DateTime.Now);

                cdaReportFundingStreamPeriodsMainstream1718AssertRecordCount =
                    context.CdaReportFundingStreamPeriods.Count(e => e.ExtractName == testExtractName);
            }

            using (var context = new ContractManagementDbContext())
            {
                Mock<IOverrideDateRepository> dateProvider = new Mock<IOverrideDateRepository>();
                dateProvider.Setup(m => m.GetDate(It.IsAny<ConnectionInfo>())).ReturnsAsync(DateTime.Now.Date);

                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                var repository = new CdaConfigRepository(new OverrideDateRepository());

                // act
                var assertCdaExtracts = repository.GetAllCdaExtracts(connectionInfo).Result;

                // assert
                Assert.IsNotNull(assertCdaExtracts, "A null response was incorrectly returned");
                Assert.AreEqual(cdaExtractAssertRecordCount, assertCdaExtracts.Count, "Incorrect number of CDAExtracts returned");

                var assertCdaReportFundingStreamPeriodsMainstream1718 = assertCdaExtracts
                    .First(c => c.ExtractName == testExtractName)
                    .CdaReportFundingStreamPeriods;

                Assert.AreEqual(cdaReportFundingStreamPeriodsMainstream1718AssertRecordCount,
                    assertCdaReportFundingStreamPeriodsMainstream1718.Count,
                    "Incorrect number of CdaReportFundingStreamPeriods returned");
            }

            ClearDownTestExtract(testExtractName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaConfigRepository_GetAllCdaExtracts_ShouldRetrieveCorrectRowsWhenDateIsOverriden()
        {
            // arrange 
            DateTime testDate = DateTime.Now.AddYears(10).Date;
            int cdaExtractRecordCount;

            using (var context = new ContractManagementDbContext())
            {
                cdaExtractRecordCount = context.CdaExtracts.Count(e => !e.ReportingCloseDate.HasValue || e.ReportingCloseDate >= testDate);
            }

            using (var context = new ContractManagementDbContext())
            {
                Mock<IOverrideDateRepository> dateProvider = new Mock<IOverrideDateRepository>();
                dateProvider.Setup(m => m.GetDate(It.IsAny<ConnectionInfo>())).ReturnsAsync(testDate);

                ConnectionInfo connectionInfo = new ConnectionInfo(null, context.Database.Connection);

                var repository = new CdaConfigRepository(dateProvider.Object);

                // act
                var assertCdaExtracts = repository.GetAllCdaExtracts(connectionInfo).Result;

                // assert
                Assert.IsNotNull(assertCdaExtracts, "A null response was incorrectly returned");
                Assert.AreEqual(cdaExtractRecordCount, assertCdaExtracts.Count, $"Incorrect number of CDAExtracts returned when override date is set to {testDate}");
            }
        }

        private void ClearDownTestExtract(string extractName)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.CdaExtracts
                    .Where(r => r.ExtractName == extractName).ToList()
                    .ForEach(ti => context.CdaExtracts.Remove(ti));

                context.SaveChanges();
            }
        }
    }
}