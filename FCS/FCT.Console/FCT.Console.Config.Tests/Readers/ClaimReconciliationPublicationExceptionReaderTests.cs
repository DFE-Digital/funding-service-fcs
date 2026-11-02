namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;

    [TestClass]
    public class ClaimReconciliationPublicationExceptionReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Rec Ref Data - Exceptions");
            ClaimReconciliationPublicationExceptionReader claimReconciliationPublicationExceptionReader = new ClaimReconciliationPublicationExceptionReader();

            // act
            IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> claimReconciliationPublicationExceptionCollectionItems = claimReconciliationPublicationExceptionReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(30, claimReconciliationPublicationExceptionCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionReader_ShouldReadArbitaryClaimReconciliationExceptionRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Rec Ref Data - Exceptions");
            ClaimReconciliationPublicationExceptionReader claimReconciliationPublicationExceptionReader = new ClaimReconciliationPublicationExceptionReader();

            // act
            IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> claimReconciliationPublicationExceptionCollectionItems = claimReconciliationPublicationExceptionReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationPublicationExceptionSheetType firstRowInSheet = claimReconciliationPublicationExceptionCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("AEB-19TRLS1920", firstRowInSheet.ClaimReconciliationAllocationGroupCode, "The claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual(10000952, firstRowInSheet.Ukprn, "The Ukprn was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Rec Ref Data - Exceptions");
            ClaimReconciliationPublicationExceptionReader claimReconciliationPublicationExceptionReader = new ClaimReconciliationPublicationExceptionReader();

            // act
            IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> claimReconciliationPublicationExceptionCollectionItems = claimReconciliationPublicationExceptionReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(30, claimReconciliationPublicationExceptionCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationPublicationExceptionReader_Json_ShouldReadArbitaryClaimReconciliationExceptionRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Rec Ref Data - Exceptions");
            ClaimReconciliationPublicationExceptionReader claimReconciliationPublicationExceptionReader = new ClaimReconciliationPublicationExceptionReader();

            // act
            IReadOnlyCollection<ClaimReconciliationPublicationExceptionSheetType> claimReconciliationPublicationExceptionCollectionItems = claimReconciliationPublicationExceptionReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationPublicationExceptionSheetType firstRowInSheet = claimReconciliationPublicationExceptionCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("AEB-19TRLS1920", firstRowInSheet.ClaimReconciliationAllocationGroupCode, "The claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual(10000952, firstRowInSheet.Ukprn, "The Ukprn was not correctly read");
        }
    }
}