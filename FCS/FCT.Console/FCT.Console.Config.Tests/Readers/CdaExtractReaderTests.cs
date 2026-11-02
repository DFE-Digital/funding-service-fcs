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
    public class CdaExtractReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("CDA Extracts");
            CdaExtractReader cdaExtractReader = new CdaExtractReader();

            // act
            IReadOnlyCollection<CdaExtractSheetType> cdaExtractCollectionItems = cdaExtractReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(105, cdaExtractCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractReader_ShouldReadArbitraryCdaExtractRowCorrectly()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("CDA Extracts");
            CdaExtractReader cdaExtractReader = new CdaExtractReader();

            // act
            IReadOnlyCollection<CdaExtractSheetType> cdaExtractCollectionItems = cdaExtractReader.ReadConfig(worksheetReader);

            // assert
            CdaExtractSheetType firstRowInSheet = cdaExtractCollectionItems.FirstOrDefault();

            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("16-18 Forensic Unit 20-21", firstRowInSheet.ExtractName, "The Extract Name was not correctly read");
            Assert.AreEqual(false, firstRowInSheet.ArchiveClosedContracts, "The Archive Closed Contracts was not correctly read");
            Assert.AreEqual(new DateTime(2022, 03, 06, 0, 0, 0, DateTimeKind.Utc), firstRowInSheet.ReportingCloseDate, "Reporting Close Date was not correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("CDA Extracts");
            CdaExtractReader cdaExtractReader = new CdaExtractReader();

            // act
            IReadOnlyCollection<CdaExtractSheetType> cdaExtractCollectionItems = cdaExtractReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(105, cdaExtractCollectionItems.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CdaExtractReader_Json_ShouldReadArbitraryCdaExtractRowCorrectly()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("CDA Extracts");
            CdaExtractReader cdaExtractReader = new CdaExtractReader();

            // act
            IReadOnlyCollection<CdaExtractSheetType> cdaExtractCollectionItems = cdaExtractReader.ReadConfig(worksheetReader);

            // assert
            CdaExtractSheetType firstRowInSheet = cdaExtractCollectionItems.FirstOrDefault();

            Assert.IsNotNull(firstRowInSheet, "The first row was not read correctly");
            Assert.AreEqual("16-18 Forensic Unit 20-21", firstRowInSheet.ExtractName, "The Extract Name was not correctly read");
            Assert.AreEqual(false, firstRowInSheet.ArchiveClosedContracts, "The Archive Closed Contracts was not correctly read");
            Assert.AreEqual(new DateTime(2022, 03, 06, 0, 0, 0, DateTimeKind.Utc), firstRowInSheet.ReportingCloseDate, "Reporting Close Date was not correctly read");
        }
    }
}
