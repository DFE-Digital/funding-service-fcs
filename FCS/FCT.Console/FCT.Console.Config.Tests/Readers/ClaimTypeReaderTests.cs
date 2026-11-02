namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimTypeReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Types");
            ClaimTypeReader claimTypeReader = new ClaimTypeReader();

            // act
            IReadOnlyCollection<ClaimTypeSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(2, claimTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimTypeReader_ShouldReadArbitaryClaimTypeRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Types");
            ClaimTypeReader claimTypeReader = new ClaimTypeReader();

            // act
            IReadOnlyCollection<ClaimTypeSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            ClaimTypeSheetType firstRowInSheet = claimTypeItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("YE", firstRowInSheet.ClaimTypeCode, "the claim type code was not correctly read");
            Assert.AreEqual("Year End", firstRowInSheet.Name, "the claim type name was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimTypeReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Types");
            ClaimTypeReader claimTypeReader = new ClaimTypeReader();

            // act
            IReadOnlyCollection<ClaimTypeSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(2, claimTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimTypeReader_Json_ShouldReadArbitaryClaimTypeRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Types");
            ClaimTypeReader claimTypeReader = new ClaimTypeReader();

            // act
            IReadOnlyCollection<ClaimTypeSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            ClaimTypeSheetType firstRowInSheet = claimTypeItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("YE", firstRowInSheet.ClaimTypeCode, "the claim type code was not correctly read");
            Assert.AreEqual("Year End", firstRowInSheet.Name, "the claim type name was not correctly read");
        }
    }
}
