namespace FCT.Console.Config.Tests.Readers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingPeriodSheetTypeReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingPeriodReader_ShouldReadInAllRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("Funding Period");
            FundingPeriodSheetTypeReader fundingPeriodSheetTypeReader = new FundingPeriodSheetTypeReader();

            // act
            IEnumerable<FundingPeriodSheetType> fundingStreamModels = fundingPeriodSheetTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(34, fundingStreamModels.Count(), "The number of rows that has been read differs");
            Assert.AreEqual(new DateTime(2023,9,1), fundingStreamModels.ToArray().Last().StartDate.Value, "The start date has not been correctly read");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingPeriodReader_Json_ShouldReadInAllRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("Funding Period");
            FundingPeriodSheetTypeReader fundingPeriodSheetTypeReader = new FundingPeriodSheetTypeReader();

            // act
            IEnumerable<FundingPeriodSheetType> fundingStreamModels = fundingPeriodSheetTypeReader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(34, fundingStreamModels.Count(), "The number of rows that has been read differs");
            Assert.AreEqual(new DateTime(2023, 9, 1), fundingStreamModels.ToArray().Last().StartDate.Value, "The start date has not been correctly read");
        }
    }
}
