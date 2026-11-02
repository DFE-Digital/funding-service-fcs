namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingTypeStreamRelationshipReaderTests : TestBase
    {
        private WorkbookReader _workbookReader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _workbookReader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeStreamRelationshipReader_ShouldReadInAllRows()
        {
            // arrange
            _workbookReader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _workbookReader.WorksheetReader("Funding Type Stream Relationshi");
            FundingTypeStreamRelationshipReader reader = new FundingTypeStreamRelationshipReader();

            // act
            IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> fundingTypeStreamRelationshipSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(111, fundingTypeStreamRelationshipSheetTypes.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingTypeStreamRelationshipReader_json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Type Stream Relationshi");
            FundingTypeStreamRelationshipReader reader = new FundingTypeStreamRelationshipReader();

            // act
            IReadOnlyCollection<FundingTypeStreamRelationshipSheetType> fundingTypeStreamRelationshipSheetTypes = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(111, fundingTypeStreamRelationshipSheetTypes.Count);
        }
    }
}
