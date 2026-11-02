namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimReconciliationDelGroupsReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;
        private const string ClaimRecSheetName = "Claim Reconciliation Del Groups";

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(65, claimReconciliationDelGroupsCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_ShouldReadArbitaryClaimReconciliationDelGroupsRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationDelGroupsSheetType firstRowInSheet = claimReconciliationDelGroupsCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("ASC1516_APPS", firstRowInSheet.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("Adult Apprenticeships 15/16", firstRowInSheet.ClaimReconciliationDeliverableGroupName, "the claim reconciliation deliverable group name was not correctly read");
            Assert.AreEqual(false, firstRowInSheet.CapClaimToProfile, "the cap claim to profile was not correctly read");
            Assert.IsFalse(firstRowInSheet.ObtainProfileFromReferenceData, "The Obtain Profile from Reference Data column was not read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_WhenReadingRowsWithYesValues_ShouldTransformCorrectly()
        {
            // arrange
            const int rowIndexUnderTest = 7;
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);
            ClaimReconciliationDelGroupsSheetType rowUnderTest =
                claimReconciliationDelGroupsCollectionItems.ElementAt(rowIndexUnderTest);

            // assert
            Assert.IsNotNull(rowUnderTest, $"The row number {rowIndexUnderTest} was not read correctly");
            Assert.AreEqual("AEBC1617_CLMH", rowUnderTest.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("AEB - CL - Mental Health Research Project 16/17", rowUnderTest.ClaimReconciliationDeliverableGroupName, "the claim reconciliation deliverable group name was not correctly read");
            Assert.IsTrue(rowUnderTest.CapClaimToProfile, "the cap claim to profile was not correctly read");
            Assert.IsTrue(rowUnderTest.ObtainProfileFromReferenceData, "The Obtain Profile from Reference Data column was not read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(65, claimReconciliationDelGroupsCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_Json_ShouldReadArbitaryClaimReconciliationDelGroupsRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationDelGroupsSheetType firstRowInSheet = claimReconciliationDelGroupsCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("ASC1516_APPS", firstRowInSheet.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("Adult Apprenticeships 15/16", firstRowInSheet.ClaimReconciliationDeliverableGroupName, "the claim reconciliation deliverable group name was not correctly read");
            Assert.AreEqual(false, firstRowInSheet.CapClaimToProfile, "the cap claim to profile was not correctly read");
            Assert.IsFalse(firstRowInSheet.ObtainProfileFromReferenceData, "The Obtain Profile from Reference Data column was not read correctly");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationDelGroupsReader_Json_WhenReadingRowsWithYesValues_ShouldTransformCorrectly()
        {
            // arrange
            const int rowIndexUnderTest = 7;
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader(ClaimRecSheetName);
            ClaimReconciliationDelGroupsReader claimReconciliationDelGroupsReader = new ClaimReconciliationDelGroupsReader();

            // act
            IReadOnlyCollection<ClaimReconciliationDelGroupsSheetType> claimReconciliationDelGroupsCollectionItems = claimReconciliationDelGroupsReader.ReadConfig(worksheetReader);
            ClaimReconciliationDelGroupsSheetType rowUnderTest =
                claimReconciliationDelGroupsCollectionItems.ElementAt(rowIndexUnderTest);

            // assert
            Assert.IsNotNull(rowUnderTest, $"The row number {rowIndexUnderTest} was not read correctly");
            Assert.AreEqual("AEBC1617_CLMH", rowUnderTest.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("AEB - CL - Mental Health Research Project 16/17", rowUnderTest.ClaimReconciliationDeliverableGroupName, "the claim reconciliation deliverable group name was not correctly read");
            Assert.IsTrue(rowUnderTest.CapClaimToProfile, "the cap claim to profile was not correctly read");
            Assert.IsTrue(rowUnderTest.ObtainProfileFromReferenceData, "The Obtain Profile from Reference Data column was not read correctly");
        }
    }
}
