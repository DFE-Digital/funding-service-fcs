namespace FCT.Console.Config.Tests.Readers
{
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;

    [TestClass]
    public class ClaimReconciliationReferenceDataReconProfilingReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Claim Rec Ref Data - Recon Prof");
            var claimReconciliationReferenceDataReconProfilingReader = new ClaimReconciliationReferenceDataReconProfilingReader();

            // act
            var items = claimReconciliationReferenceDataReconProfilingReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(297, items.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClaimReconciliationReferenceDataReconProfilingReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Claim Rec Ref Data - Recon Prof");
            var claimReconciliationReferenceDataReconProfilingReader = new ClaimReconciliationReferenceDataReconProfilingReader();

            // act
            var items = claimReconciliationReferenceDataReconProfilingReader.ReadConfig(worksheetReader);

            // asserts
            Assert.AreEqual(297, items.Count);
        }
    }
}