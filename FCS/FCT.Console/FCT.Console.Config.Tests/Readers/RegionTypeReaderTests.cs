namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class RegionTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeReader_ShouldReadAllRows()
        {
            // Arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Region Types");
            RegionTypeReader reader = new RegionTypeReader();
            
            // Act
            IEnumerable<RegionTypeSheetType> regionTypeSheetTypes = reader.ReadConfig(worksheetReader);

            // Assert
            Assert.AreEqual(3, regionTypeSheetTypes.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeReader_ShouldReadARowCorrectly()
        {
            // Arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Region Types");
            RegionTypeReader reader = new RegionTypeReader();

            // Act
            IEnumerable<RegionTypeSheetType> regionTypeSheetTypes = reader.ReadConfig(worksheetReader);
            RegionTypeSheetType firstRow = regionTypeSheetTypes.First();

            // Assert
            Assert.AreEqual("Less Developed", firstRow.RegionTypeName);
            Assert.AreEqual(1, firstRow.RegionTypeCode);

        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeReader_Json_ShouldReadAllRows()
        {
            // Arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Region Types");
            RegionTypeReader reader = new RegionTypeReader();

            // Act
            IEnumerable<RegionTypeSheetType> regionTypeSheetTypes = reader.ReadConfig(worksheetReader);

            // Assert
            Assert.AreEqual(3, regionTypeSheetTypes.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RegionTypeReader_Json_ShouldReadARowCorrectly()
        {
            // Arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Region Types");
            RegionTypeReader reader = new RegionTypeReader();

            // Act
            IEnumerable<RegionTypeSheetType> regionTypeSheetTypes = reader.ReadConfig(worksheetReader);
            RegionTypeSheetType firstRow = regionTypeSheetTypes.First();

            // Assert
            Assert.AreEqual("Less Developed", firstRow.RegionTypeName);
            Assert.AreEqual(1, firstRow.RegionTypeCode);

        }
    }
}
