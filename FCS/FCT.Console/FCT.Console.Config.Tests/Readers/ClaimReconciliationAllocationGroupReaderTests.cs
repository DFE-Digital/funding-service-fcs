namespace FCT.Console.Config.Tests.Readers
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;

    [TestClass]
    public class ClaimReconciliationAllocationGroupReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Recon Alloc Groups");
            ClaimReconciliationAllocationGroupReader claimTypeReader = new ClaimReconciliationAllocationGroupReader();

            // act
            IReadOnlyCollection<ClaimReconciliationAllocationGroupSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(46, claimTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupReader_ShouldReadArbitaryClaimReconAllocGroupRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Recon Alloc Groups");
            ClaimReconciliationAllocationGroupReader claimTypeReader = new ClaimReconciliationAllocationGroupReader();

            // act
            IReadOnlyCollection<ClaimReconciliationAllocationGroupSheetType> claimReconAllocGroupItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationAllocationGroupSheetType thirdRowInSheet = claimReconAllocGroupItems.Skip(2).FirstOrDefault();
            Assert.IsNotNull(thirdRowInSheet, "The third row was not read correctly");
            Assert.AreEqual("DLSALLBC1516", thirdRowInSheet.ClaimReconciliationAllocationGroupCode, "the claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual("DLS and Advanced Learner Loans Bursary 15/16", thirdRowInSheet.GroupName, "the claim reconciliation allocation group name was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Recon Alloc Groups");
            ClaimReconciliationAllocationGroupReader claimTypeReader = new ClaimReconciliationAllocationGroupReader();

            // act
            IReadOnlyCollection<ClaimReconciliationAllocationGroupSheetType> claimTypeItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(46, claimTypeItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationAllocationGroupReader_Json_ShouldReadArbitaryClaimReconAllocGroupRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Recon Alloc Groups");
            ClaimReconciliationAllocationGroupReader claimTypeReader = new ClaimReconciliationAllocationGroupReader();

            // act
            IReadOnlyCollection<ClaimReconciliationAllocationGroupSheetType> claimReconAllocGroupItems = claimTypeReader.ReadConfig(worksheetReader);

            // assert
            ClaimReconciliationAllocationGroupSheetType thirdRowInSheet = claimReconAllocGroupItems.Skip(2).FirstOrDefault();
            Assert.IsNotNull(thirdRowInSheet, "The third row was not read correctly");
            Assert.AreEqual("DLSALLBC1516", thirdRowInSheet.ClaimReconciliationAllocationGroupCode, "the claim reconciliation allocation group code was not correctly read");
            Assert.AreEqual("DLS and Advanced Learner Loans Bursary 15/16", thirdRowInSheet.GroupName, "the claim reconciliation allocation group name was not correctly read");
        }
    }
}
