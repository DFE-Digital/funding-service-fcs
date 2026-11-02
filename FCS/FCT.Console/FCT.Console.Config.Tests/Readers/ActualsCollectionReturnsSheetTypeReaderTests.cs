namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ActualsCollectionReturnsSheetTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ActualsCollectionReturnsSheetTypeReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Actuals Collection Returns");

            ActualsCollectionReturnsReader actualsCollectionReturnsReader = new ActualsCollectionReturnsReader();

            // act
            IReadOnlyCollection<ActualsCollectionReturnsSheetType> actualsCollectionReturnsSheetTypeItems = actualsCollectionReturnsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(224, actualsCollectionReturnsSheetTypeItems.Count, "The number of rows read in is incorrect");
            string collectionReturnCode = actualsCollectionReturnsSheetTypeItems.Single(sheetType => sheetType.MultipleCollectionGroupId == 1
                                                                                                  && sheetType.FundingStreamPeriodCode == "APPS1819"
                                                                                                  && sheetType.CollectionType == "APPS").CollectionReturnCode;
            Assert.AreEqual("APPS16", collectionReturnCode, "The CollectionReturnCode is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ActualsCollectionReturnsSheetTypeReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            var worksheetReader = _jsonReader.WorksheetReader("Actuals Collection Returns");

            var actualsCollectionReturnsReader = new ActualsCollectionReturnsReader();

            // act
            var actualsCollectionReturnsSheetTypeItems = actualsCollectionReturnsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(224, actualsCollectionReturnsSheetTypeItems.Count, "The number of rows read in is incorrect");
            string collectionReturnCode = actualsCollectionReturnsSheetTypeItems.Single(sheetType => sheetType.MultipleCollectionGroupId == 1
                                                                                                     && sheetType.FundingStreamPeriodCode == "APPS1819"
                                                                                                     && sheetType.CollectionType == "APPS").CollectionReturnCode;
            Assert.AreEqual("APPS16", collectionReturnCode, "The CollectionReturnCode is incorrect");
        }

    }
}