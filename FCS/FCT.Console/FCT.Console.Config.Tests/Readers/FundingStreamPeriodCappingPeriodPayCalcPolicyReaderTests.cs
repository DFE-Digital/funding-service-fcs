namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Excel;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingStreamPeriodCappingPeriodPayCalcPolicyReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingPeriodPayCalcPolicyReader_ShouldReadAllPublishedRows()
        {
            // arrange
            const string sheetName = "FSP CP Pay Calc Policy";
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader(sheetName);
            var reader = new FundingStreamPeriodCappingPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(112, rows.Count(), $"'{sheetName}' has unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingPeriodPayCalcPolicyReader_ShouldReadArbitraryRowValues()
        {
            // arrange
            const string sheetName = "FSP CP Pay Calc Policy";
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader(sheetName);
            var reader = new FundingStreamPeriodCappingPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            var row = rows.SingleOrDefault(st =>
                st.FundingStreamPeriodCode == "AEB-19TRN1920" && st.CalcPolicyVersion == 3);

            Assert.IsNotNull(row, "Row not found");
            Assert.AreEqual("AEB-19TRN1920", row.FundingStreamPeriodCode, $"'{sheetName}' - FundingStreamPeriodCode incorrect");
            Assert.AreEqual(3, row.CalcPolicyVersion, $"'{sheetName}' - CalcPolicyVersion incorrect");
            Assert.AreEqual(1, row.CappingPeriod, $"'{sheetName}' - CappingPeriod incorrect");
            Assert.AreEqual(10, row.OverDeliveryLimit, $"'{sheetName}' - OverDeliveryLimit incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingPeriodPayCalcPolicyReader_Json_ShouldReadAllPublishedRows()
        {
            // arrange
            const string sheetName = "FSP CP Pay Calc Policy";
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader(sheetName);
            var reader = new FundingStreamPeriodCappingPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(112, rows.Count(), $"'{sheetName}' has unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingPeriodPayCalcPolicyReader_Json_ShouldReadArbitraryRowValues()
        {
            // arrange
            const string sheetName = "FSP CP Pay Calc Policy";
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader(sheetName);
            var reader = new FundingStreamPeriodCappingPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodCappingPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            var row = rows.SingleOrDefault(st =>
                st.FundingStreamPeriodCode == "AEB-19TRN1920" && st.CalcPolicyVersion == 3);

            Assert.IsNotNull(row, "Row not found");
            Assert.AreEqual("AEB-19TRN1920", row.FundingStreamPeriodCode, $"'{sheetName}' - FundingStreamPeriodCode incorrect");
            Assert.AreEqual(3, row.CalcPolicyVersion, $"'{sheetName}' - CalcPolicyVersion incorrect");
            Assert.AreEqual(1, row.CappingPeriod, $"'{sheetName}' - CappingPeriod incorrect");
            Assert.AreEqual(10, row.OverDeliveryLimit, $"'{sheetName}' - OverDeliveryLimit incorrect");
        }
    }
}