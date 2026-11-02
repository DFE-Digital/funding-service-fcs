namespace FCT.Console.Config.Tests.Readers
{
    using System.Linq;
    using Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class AllocationFundingStreamReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationFundingStreamReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Allocation Funding Streams");
            var allocationFundingStreamReader = new AllocationFundingStreamReader();

            // act
            var allocationFundingStreamRows = allocationFundingStreamReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(67, allocationFundingStreamRows.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationFundingStreamReader_ShouldReadCorrectValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Allocation Funding Streams");
            var allocationFundingStreamReader = new AllocationFundingStreamReader();

            // act
            var allocationFundingStreamRows = allocationFundingStreamReader.ReadConfig(worksheetReader);

            // assert
            var allocationFundingStreamRow = allocationFundingStreamRows
                .Single(afscr => afscr.AllocationFundingStreamCode == "NMSS" && afscr.AllocationPeriodId == "AY-2021");

            Assert.AreEqual("EDSK", allocationFundingStreamRow.FundingTypeCode, "The FundingTypeCode has not been read correctly");
            Assert.AreEqual("AY2021", allocationFundingStreamRow.FundingPeriodCode, "The FundingPeriodCode has not been read correctly");
            Assert.AreEqual("16-19ED2021", allocationFundingStreamRow.FSPGroupCode, "The FSPGroupCode has not been read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationFundingStreamReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Allocation Funding Streams");
            var allocationFundingStreamReader = new AllocationFundingStreamReader();

            // act
            var allocationFundingStreamRows = allocationFundingStreamReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(67, allocationFundingStreamRows.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationFundingStreamReader_Json_ShouldReadCorrectValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Allocation Funding Streams");
            var allocationFundingStreamReader = new AllocationFundingStreamReader();

            // act
            var allocationFundingStreamRows = allocationFundingStreamReader.ReadConfig(worksheetReader);

            // assert
            var allocationFundingStreamRow = allocationFundingStreamRows
                .Single(afscr => afscr.AllocationFundingStreamCode == "NMSS" && afscr.AllocationPeriodId == "AY-2021");

            Assert.AreEqual("EDSK", allocationFundingStreamRow.FundingTypeCode, "The FundingTypeCode has not been read correctly");
            Assert.AreEqual("AY2021", allocationFundingStreamRow.FundingPeriodCode, "The FundingPeriodCode has not been read correctly");
            Assert.AreEqual("16-19ED2021", allocationFundingStreamRow.FSPGroupCode, "The FSPGroupCode has not been read correctly");
        }
    }
}