namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Linq;
    using Config.Excel;

    [TestClass]
    public class FundingTypePeriodFundingStreamPeriodReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FTP-FSP");
            var reader = new FundingTypePeriodFundingStreamPeriodReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(260, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodReader_ShouldReadArbitraryCdaExtractRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FTP-FSP");
            var reader = new FundingTypePeriodFundingStreamPeriodReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            var assertRow = rows.FirstOrDefault(r =>
                r.FundingTypeCode == "MAIN" && r.FundingPeriodCode == "AY1920" && r.FundingStreamCode == "APPS");

            Assert.IsNotNull(assertRow, "The row was not read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FTP-FSP");
            var reader = new FundingTypePeriodFundingStreamPeriodReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(260, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypePeriodFundingStreamPeriodReader_Json_ShouldReadArbitraryCdaExtractRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FTP-FSP");
            var reader = new FundingTypePeriodFundingStreamPeriodReader();

            // act
            var rows = reader.ReadConfig(worksheetReader);

            // assert
            var assertRow = rows.FirstOrDefault(r =>
                r.FundingTypeCode == "MAIN" && r.FundingPeriodCode == "AY1920" && r.FundingStreamCode == "APPS");

            Assert.IsNotNull(assertRow, "The row was not read correctly");
        }
    }
}