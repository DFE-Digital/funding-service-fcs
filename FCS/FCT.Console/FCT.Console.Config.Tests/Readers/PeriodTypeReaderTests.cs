namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class PeriodTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PeriodTypeReader_ShouldReadCalendarYear()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Period Type");
            PeriodTypeReader reader = new PeriodTypeReader();

            // act
            IEnumerable<PeriodTypeSheetType> periodTypeSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            PeriodTypeSheetType sheetType = periodTypeSheetTypes.Single(
                pt => pt.PeriodTypeCode == "CY");
            Assert.AreEqual(sheetType.PeriodTypeName, "Calendar Year");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PeriodTypeReader_Json_ShouldReadCalendarYear()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Period Type");
            PeriodTypeReader reader = new PeriodTypeReader();

            // act
            IEnumerable<PeriodTypeSheetType> periodTypeSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            PeriodTypeSheetType sheetType = periodTypeSheetTypes.Single(
                pt => pt.PeriodTypeCode == "CY");
            Assert.AreEqual(sheetType.PeriodTypeName, "Calendar Year");
        }
    }
}
