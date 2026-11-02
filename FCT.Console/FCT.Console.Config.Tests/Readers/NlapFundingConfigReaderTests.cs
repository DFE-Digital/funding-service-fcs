namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class NlapFundingConfigReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigReader_ShouldReadAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("NLAP Contract Ref Data");
            NlapFundingConfigReader reader = new NlapFundingConfigReader();

            // act
            IEnumerable<NlapFundingConfigSheet> sheets = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(633, sheets.Count(), "Unexpected number of sheets returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigReader_ShouldReadArbitraryRowValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("NLAP Contract Ref Data");
            NlapFundingConfigReader reader = new NlapFundingConfigReader();

            // act
            IEnumerable<NlapFundingConfigSheet> rows = reader.ReadConfig(worksheetReader);

            // assert
            NlapFundingConfigSheet sheet = rows.SingleOrDefault(s => s.Ukprn == 10000950);

            Assert.IsNotNull(sheet, "NLAP Funding Config sheet not found");
            Assert.AreEqual(528949m, sheet.NewStarts2021Funding1618, "NLAP Contract Ref Data - NewStarts2021Funding1618 incorrect");
            Assert.AreEqual(740189m, sheet.NewStarts2021FundingAdult, "NLAP Contract Ref Data - NewStarts2021FundingAdult incorrect");

            Assert.AreEqual(1172387m, sheet.NewStartsEstimatedFutureFunding1618, "NLAP Contract Ref Data - NewStartsEstimatedFutureFunding1618 incorrect");
            Assert.AreEqual(1258136m, sheet.NewStartsEstimatedFutureFundingAdult, "NLAP Contract Ref Data - NewStartsEstimatedFutureFundingAdult incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigReader_Json_ShouldReadAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("NLAP Contract Ref Data");
            NlapFundingConfigReader reader = new NlapFundingConfigReader();

            // act
            IEnumerable<NlapFundingConfigSheet> sheets = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(633, sheets.Count(), "Unexpected number of sheets returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void NlapFundingConfigReader_Json_ShouldReadArbitraryRowValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("NLAP Contract Ref Data");
            NlapFundingConfigReader reader = new NlapFundingConfigReader();

            // act
            IEnumerable<NlapFundingConfigSheet> rows = reader.ReadConfig(worksheetReader);

            // assert
            NlapFundingConfigSheet sheet = rows.SingleOrDefault(s => s.Ukprn == 10000950);

            Assert.IsNotNull(sheet, "NLAP Funding Config sheet not found");
            Assert.AreEqual(528949m, sheet.NewStarts2021Funding1618, "NLAP Contract Ref Data - NewStarts2021Funding1618 incorrect");
            Assert.AreEqual(740189m, sheet.NewStarts2021FundingAdult, "NLAP Contract Ref Data - NewStarts2021FundingAdult incorrect");

            Assert.AreEqual(1172387m, sheet.NewStartsEstimatedFutureFunding1618, "NLAP Contract Ref Data - NewStartsEstimatedFutureFunding1618 incorrect");
            Assert.AreEqual(1258136m, sheet.NewStartsEstimatedFutureFundingAdult, "NLAP Contract Ref Data - NewStartsEstimatedFutureFundingAdult incorrect");
        }
    }
}
