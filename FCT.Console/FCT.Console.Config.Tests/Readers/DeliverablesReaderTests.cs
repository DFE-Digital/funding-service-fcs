namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class DeliverablesReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablesReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Deliverable");
            DeliverablesReader fundingStreamConfigReader = new DeliverablesReader();

            // act
            IReadOnlyCollection<DeliverablesSheetType> deliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(1956, deliverablesItems.Count);
            DateTime effectDateTime = new DateTime(
                year: 2015,
                month: 8,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
                kind: DateTimeKind.Utc);
            Assert.AreEqual(effectDateTime, deliverablesItems.First().EffectiveDate, "The EffectiveDate has not been read in correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablesReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Deliverable");
            DeliverablesReader fundingStreamConfigReader = new DeliverablesReader();

            // act
            IReadOnlyCollection<DeliverablesSheetType> deliverablesItems = fundingStreamConfigReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(1956, deliverablesItems.Count);
            DateTime effectDateTime = new DateTime(
                year: 2015,
                month: 8,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0,
                kind: DateTimeKind.Utc);
            Assert.AreEqual(effectDateTime, deliverablesItems.First().EffectiveDate, "The EffectiveDate has not been read in correctly");
        }
    }
}