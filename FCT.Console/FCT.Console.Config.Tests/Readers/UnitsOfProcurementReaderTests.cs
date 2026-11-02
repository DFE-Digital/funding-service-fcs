namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class UnitsOfProcurementReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void Cleanup()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UnitsOfProcurementReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Units of Procurement");
            UnitsOfProcurementReader unitsOfProcurementReader = new UnitsOfProcurementReader();

            // act
            IReadOnlyCollection<UnitsOfProcurementSheetType> unitsOfProcurement =
                unitsOfProcurementReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(48, unitsOfProcurement.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UnitsOfProcurementReader_ShouldReadArbitraryUopRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Units of Procurement");
            UnitsOfProcurementReader unitsOfProcurementReader = new UnitsOfProcurementReader();

            // act
            IReadOnlyCollection<UnitsOfProcurementSheetType> unitsOfProcurement =
                unitsOfProcurementReader.ReadConfig(worksheetReader);

            // assert
            UnitsOfProcurementSheetType fourthRowInSheet = unitsOfProcurement.Skip(3).FirstOrDefault();
            Assert.IsNotNull(fourthRowInSheet, "The fourth row was not read correctly");
            Assert.AreEqual("NCS", fourthRowInSheet.Procurement);
            Assert.AreEqual("0000000004", fourthRowInSheet.UoPCode);
            Assert.AreEqual("Yorkshire and the Humber", fourthRowInSheet.UoPName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UnitsOfProcurementReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Units of Procurement");
            UnitsOfProcurementReader unitsOfProcurementReader = new UnitsOfProcurementReader();

            // act
            IReadOnlyCollection<UnitsOfProcurementSheetType> unitsOfProcurement =
                unitsOfProcurementReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(48, unitsOfProcurement.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UnitsOfProcurementReader_Json_ShouldReadArbitraryUopRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Units of Procurement");
            UnitsOfProcurementReader unitsOfProcurementReader = new UnitsOfProcurementReader();

            // act
            IReadOnlyCollection<UnitsOfProcurementSheetType> unitsOfProcurement =
                unitsOfProcurementReader.ReadConfig(worksheetReader);

            // assert
            UnitsOfProcurementSheetType fourthRowInSheet = unitsOfProcurement.Skip(3).FirstOrDefault();
            Assert.IsNotNull(fourthRowInSheet, "The fourth row was not read correctly");
            Assert.AreEqual("NCS", fourthRowInSheet.Procurement);
            Assert.AreEqual("0000000004", fourthRowInSheet.UoPCode);
            Assert.AreEqual("Yorkshire and the Humber", fourthRowInSheet.UoPName);
        }
    }
}