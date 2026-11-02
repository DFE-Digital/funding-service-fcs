namespace FCT.Console.Config.Tests.Readers
{
    using FCT.Console.Config.Excel;
    using ExcelTypes;
    using FCT.Console.Config.Synchronizers.Readers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using UnitTests.Common;

    [TestClass]
    public class AgencyReaderTests : TestBase
    {
        private WorkbookReader _reader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AgencyReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            var worksheetReader = _reader.WorksheetReader("Agency");
            AgencyReader agencySheetReader = new AgencyReader();

            // act
            IReadOnlyCollection<AgencySheetType> agencySheetRecords = agencySheetReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(1, agencySheetRecords.Count);

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AgencyReader_Json_ShouldReadInAllRowsConcrete()
        {
            // arrange
            JsonWorkbookReader jsonWorkbookReader;
            using (var resource = new TestResource("FCT.Console.Config.Tests", @"Resources.Config.json"))
            {
                jsonWorkbookReader = new JsonWorkbookReader(resource.Stream);
            }

            var worksheetReader = jsonWorkbookReader.WorksheetReader("Agency");
            AgencyReader agencySheetReader = new AgencyReader();

            // act
            IReadOnlyCollection<AgencySheetType> agencySheetRecords = agencySheetReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(1, agencySheetRecords.Count);

        }
    }
}
