namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Linq;
    using Config.Excel;
    using System.Collections.Generic;
    using FCT.Console.Config.ExcelTypes;
    using System;

    [TestClass]
    public class FundingStreamSheetReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;
        private const string AgencyCode = "1";

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamSheetReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Stream");
            var reader = new FundingStreamSheetReader();

            // act
            var rows = reader.ReadConfig(worksheetReader, AgencyCode);

            // assert
            Assert.AreEqual(101, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamSheetReader_ShouldReadArbitraryFundingStreamRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            
            var worksheetReader = _reader.WorksheetReader("Funding Stream");
            var reader = new FundingStreamSheetReader();
            
            // act
            IReadOnlyCollection<FundingStreamSheetType> rows = reader.ReadConfig(worksheetReader, AgencyCode);

            // assert
            var assertRow = rows.FirstOrDefault(r => r.Code == "OLASS");
            Assert.AreEqual("Adult OLASS", assertRow.Name, "Funding Stream Name is incorrect");
            Assert.AreEqual("LASS", assertRow.FinanceShortCode, "FinanceShortCode is incorrect");
            Assert.AreEqual(new DateTime(2015,8,1), assertRow.StartDate, "StartDate is incorrect");
            Assert.IsNull( assertRow.EndDate, "EndDate is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamSheetReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Stream");
            var reader = new FundingStreamSheetReader();

            // act
            var rows = reader.ReadConfig(worksheetReader, AgencyCode);

            // assert
            Assert.AreEqual(101, rows.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamSheetReader_Json_ShouldReadArbitraryFundingStreamRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();

            var worksheetReader = _jsonReader.WorksheetReader("Funding Stream");
            var reader = new FundingStreamSheetReader();

            // act
            IReadOnlyCollection<FundingStreamSheetType> rows = reader.ReadConfig(worksheetReader, AgencyCode);

            // assert
            var assertRow = rows.FirstOrDefault(r => r.Code == "OLASS");
            Assert.AreEqual("Adult OLASS", assertRow.Name, "Funding Stream Name is incorrect");
            Assert.AreEqual("LASS", assertRow.FinanceShortCode, "FinanceShortCode is incorrect");
            Assert.AreEqual(new DateTime(2015, 8, 1), assertRow.StartDate, "StartDate is incorrect");
            Assert.IsNull(assertRow.EndDate, "EndDate is incorrect");
        }
    }
}