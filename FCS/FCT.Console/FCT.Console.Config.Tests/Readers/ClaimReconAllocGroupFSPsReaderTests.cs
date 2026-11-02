namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimReconAllocGroupFSPsReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconAllocGroupFSPsReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Recon Alloc Group FSPs");
            ClaimReconAllocGroupFSPsReader claimReconAllocGroupFSPsReader = new ClaimReconAllocGroupFSPsReader();

            // act
            IReadOnlyCollection<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPsItems = claimReconAllocGroupFSPsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(47, claimReconAllocGroupFSPsItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconAllocGroupFSPsReader_ShouldReadArbitaryClaimReconAllocGroupFspRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Recon Alloc Group FSPs");
            ClaimReconAllocGroupFSPsReader claimReconAllocGroupFSPsReader = new ClaimReconAllocGroupFSPsReader();

            // act
            IReadOnlyCollection<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPsItems = claimReconAllocGroupFSPsReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconAllocGroupFSPSheetType firstRowInSheet = claimReconAllocGroupFSPsItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("ASC1516", firstRowInSheet.ClaimReconciliationAllocationGroupCode, "the claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual("ASC1516", firstRowInSheet.FSPCode, "the FSP code was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconAllocGroupFSPsReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Recon Alloc Group FSPs");
            ClaimReconAllocGroupFSPsReader claimReconAllocGroupFSPsReader = new ClaimReconAllocGroupFSPsReader();

            // act
            IReadOnlyCollection<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPsItems = claimReconAllocGroupFSPsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(47, claimReconAllocGroupFSPsItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")] public void ClaimReconAllocGroupFSPsReader_Json_ShouldReadArbitaryClaimReconAllocGroupFspRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Recon Alloc Group FSPs");
            ClaimReconAllocGroupFSPsReader claimReconAllocGroupFSPsReader = new ClaimReconAllocGroupFSPsReader();

            // act
            IReadOnlyCollection<ClaimReconAllocGroupFSPSheetType> claimReconAllocGroupFSPsItems = claimReconAllocGroupFSPsReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconAllocGroupFSPSheetType firstRowInSheet = claimReconAllocGroupFSPsItems.FirstOrDefault();
            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("ASC1516", firstRowInSheet.ClaimReconciliationAllocationGroupCode, "the claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual("ASC1516", firstRowInSheet.FSPCode, "the FSP code was not correctly read");
        }
    }
}
