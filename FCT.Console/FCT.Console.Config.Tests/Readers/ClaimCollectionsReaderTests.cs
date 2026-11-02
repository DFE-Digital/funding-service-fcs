namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimCollectionsReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimCollectionsReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Collections");
            ClaimCollectionsReader claimCollectionsReader = new ClaimCollectionsReader();

            // act
            IReadOnlyCollection<ClaimCollectionsSheetType> claimCollectionsItems = claimCollectionsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(20, claimCollectionsItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimCollectionsReader_ShouldReadArbitaryClaimCollectionRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Collections");
            ClaimCollectionsReader claimCollectionsReader = new ClaimCollectionsReader();

            // act
            IReadOnlyCollection<ClaimCollectionsSheetType> claimCollectionsItems = claimCollectionsReader.ReadConfig(worksheetReader);

            // assert
            ClaimCollectionsSheetType firstRowInSheet = claimCollectionsItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("1516-YearEnd", firstRowInSheet.ClaimCollectionCode, "the claim collection code was not correctly read");
            Assert.AreEqual("YE", firstRowInSheet.ClaimTypeCode, "the claim type name was not correctly read");
            Assert.AreEqual("1516", firstRowInSheet.Period, "the period was not correctly read");
            Assert.AreEqual("AY", firstRowInSheet.PeriodType, "the period type was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimCollectionsReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Collections");
            ClaimCollectionsReader claimCollectionsReader = new ClaimCollectionsReader();

            // act
            IReadOnlyCollection<ClaimCollectionsSheetType> claimCollectionsItems = claimCollectionsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(20, claimCollectionsItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimCollectionsReader_Json_ShouldReadArbitaryClaimCollectionRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Collections");
            ClaimCollectionsReader claimCollectionsReader = new ClaimCollectionsReader();

            // act
            IReadOnlyCollection<ClaimCollectionsSheetType> claimCollectionsItems = claimCollectionsReader.ReadConfig(worksheetReader);

            // assert
            ClaimCollectionsSheetType firstRowInSheet = claimCollectionsItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("1516-YearEnd", firstRowInSheet.ClaimCollectionCode, "the claim collection code was not correctly read");
            Assert.AreEqual("YE", firstRowInSheet.ClaimTypeCode, "the claim type name was not correctly read");
            Assert.AreEqual("1516", firstRowInSheet.Period, "the period was not correctly read");
            Assert.AreEqual("AY", firstRowInSheet.PeriodType, "the period type was not correctly read");
        }
    }
}
