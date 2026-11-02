namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;
    using Config.Excel;

    [TestClass]
    public class FundingStreamPeriodCappginGroupReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingGroupsReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Capping Groups");
            FundingStreamPeriodCappingGroupsReader fundingStreamPeriodCappingGroupsReader = new FundingStreamPeriodCappingGroupsReader();

            // act
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> fundingStreamPeriodCappingGroupsItems = fundingStreamPeriodCappingGroupsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(55, fundingStreamPeriodCappingGroupsItems.Count());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingGroupsReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Capping Groups");
            FundingStreamPeriodCappingGroupsReader fundingStreamPeriodCappingGroupsReader = new FundingStreamPeriodCappingGroupsReader();

            // act
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> fundingStreamPeriodCappingGroupsItems = fundingStreamPeriodCappingGroupsReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(55, fundingStreamPeriodCappingGroupsItems.Count());
        }
    }
}