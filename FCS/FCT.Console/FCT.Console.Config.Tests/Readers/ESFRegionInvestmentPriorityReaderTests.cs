namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class ESFRegionInvestmentPriorityReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ESFRegionInvestmentPriorityReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("ESF Region Investment Priority");
            ESFRegionInvestmentPriorityReader fundingStreamConfigReader = new ESFRegionInvestmentPriorityReader();

            // act
            IEnumerable<ESFRegionInvestmentPrioritySheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader).ToList();

            // assert
            Assert.AreEqual(15, subnominalItems.Count());
            ESFRegionInvestmentPrioritySheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("2671111", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("1.1", subnominalsSheetType.InvestmentPriorityString);
            Assert.AreEqual("LessDeveloped", subnominalsSheetType.RegionType);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ESFRegionInvestmentPriorityReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("ESF Region Investment Priority");
            ESFRegionInvestmentPriorityReader fundingStreamConfigReader = new ESFRegionInvestmentPriorityReader();

            // act
            IEnumerable<ESFRegionInvestmentPrioritySheetType> subnominalItems = fundingStreamConfigReader.ReadConfig(worksheetReader).ToList();

            // assert
            Assert.AreEqual(15, subnominalItems.Count());
            ESFRegionInvestmentPrioritySheetType subnominalsSheetType = subnominalItems.First();

            Assert.AreEqual("2671111", subnominalsSheetType.SubnominalCode);
            Assert.AreEqual("1.1", subnominalsSheetType.InvestmentPriorityString);
            Assert.AreEqual("LessDeveloped", subnominalsSheetType.RegionType);
        }

    }
}