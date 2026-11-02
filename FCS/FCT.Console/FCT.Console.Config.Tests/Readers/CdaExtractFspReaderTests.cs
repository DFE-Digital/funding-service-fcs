
namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Linq;
    using Config.Excel;

    [TestClass]
    public class CdaExtractFspReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("CDA Extract FSPs");
            var cdaExtractFspReader = new CdaExtractFspReader();

            // act
            var rows = cdaExtractFspReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(274, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspReader_ShouldReadArbitraryCdaExtractFspRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("CDA Extract FSPs");
            var cdaExtractFspReader = new CdaExtractFspReader();

            // act
            var rows = cdaExtractFspReader.ReadConfig(worksheetReader);

            // assert
            var assertRow = rows.FirstOrDefault(r => r.ExtractName == "16-19 Funding 17-18" && r.FundingStreamPeriodCode == "SSF1718");
            Assert.IsNotNull(assertRow, "The row was not read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("CDA Extract FSPs");
            var cdaExtractFspReader = new CdaExtractFspReader();

            // act
            var rows = cdaExtractFspReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(274, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractFspReader_Json_ShouldReadArbitraryCdaExtractFspRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("CDA Extract FSPs");
            var cdaExtractFspReader = new CdaExtractFspReader();

            // act
            var rows = cdaExtractFspReader.ReadConfig(worksheetReader);

            // assert
            var assertRow = rows.FirstOrDefault(r => r.ExtractName == "16-19 Funding 17-18" && r.FundingStreamPeriodCode == "SSF1718");
            Assert.IsNotNull(assertRow, "The row was not read correctly");
        }
    }
}