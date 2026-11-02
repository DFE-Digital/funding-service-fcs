namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimReconciliationReferenceDataProfilesReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataProfileReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Rec Ref Data - Profiles");
            ClaimReconciliationReferenceDataProfilesReader claimReconciliationReferenceDataProfilesReader = new ClaimReconciliationReferenceDataProfilesReader();

            // act
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> claimReconciliationReferenceDataProfileCollectionItems = claimReconciliationReferenceDataProfilesReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(653, claimReconciliationReferenceDataProfileCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataProfileReader_ShouldReadArbitaryClaimReconciliationDelGroupsRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Rec Ref Data - Profiles");
            ClaimReconciliationReferenceDataProfilesReader claimReconciliationReferenceDataProfilesReader = new ClaimReconciliationReferenceDataProfilesReader();

            // act
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> claimReconciliationReferenceDataProfileCollectionItems = claimReconciliationReferenceDataProfilesReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationReferenceDataProfileSheetType firstRowInSheet = claimReconciliationReferenceDataProfileCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("AEBC1617_CLMH", firstRowInSheet.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("10000055", firstRowInSheet.Ukprn.ToString(), "the Ukprn was not correctly read");
            Assert.AreEqual(79960.00m, firstRowInSheet.PlannedValue, "the PlannedValue was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataProfileReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Rec Ref Data - Profiles");
            ClaimReconciliationReferenceDataProfilesReader claimReconciliationReferenceDataProfilesReader = new ClaimReconciliationReferenceDataProfilesReader();

            // act
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> claimReconciliationReferenceDataProfileCollectionItems = claimReconciliationReferenceDataProfilesReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(653, claimReconciliationReferenceDataProfileCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataProfileReader_Json_ShouldReadArbitaryClaimReconciliationDelGroupsRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Rec Ref Data - Profiles");
            ClaimReconciliationReferenceDataProfilesReader claimReconciliationReferenceDataProfilesReader = new ClaimReconciliationReferenceDataProfilesReader();

            // act
            IReadOnlyCollection<ClaimReconciliationReferenceDataProfileSheetType> claimReconciliationReferenceDataProfileCollectionItems = claimReconciliationReferenceDataProfilesReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationReferenceDataProfileSheetType firstRowInSheet = claimReconciliationReferenceDataProfileCollectionItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("AEBC1617_CLMH", firstRowInSheet.ClaimReconciliationDeliverableGroupCode, "the claim reconciliation deliverable group code was not correctly read");
            Assert.AreEqual("10000055", firstRowInSheet.Ukprn.ToString(), "the Ukprn was not correctly read");
            Assert.AreEqual(79960.00m, firstRowInSheet.PlannedValue, "the PlannedValue was not correctly read");
        }
    }
}