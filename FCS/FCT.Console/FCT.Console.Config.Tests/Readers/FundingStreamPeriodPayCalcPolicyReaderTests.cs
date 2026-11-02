namespace FCT.Console.Config.Tests.Readers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using FCT.Console.Config.Excel;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Readers;

    [TestClass]
    public class FundingStreamPeriodPayCalcPolicyReaderTests : TestBase
    {
        private WorkbookReader _reader;
        private JsonWorkbookReader _jsonReader;

        [TestCleanup]
        public void CleanUp()
        {
            _reader?.Dispose();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodPayCalcPolicyReader_ShouldReadAllPublishedRows()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Pay Calc Policy");
            FundingStreamPeriodPayCalcPolicyReader reader = new FundingStreamPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(74, rows.Count(), "Unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodPayCalcPolicyReader_ShouldReadArbitraryRowValues()
        {
            // arrange
            _reader = GetWorkbookReader();
            IWorksheetReader worksheetReader = _reader.WorksheetReader("FSP Pay Calc Policy");
            FundingStreamPeriodPayCalcPolicyReader reader = new FundingStreamPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodPayCalcPolicySheetType row = rows.SingleOrDefault(st => st.FundingStreamPeriodCode == "AEB-AS1920" && st.CalcPolicyVersion == 3);

            Assert.IsNotNull(row, "Row not found");
            Assert.AreEqual("AEB-AS1920", row.FundingStreamPeriodCode, "FSP Pay Calc Policy - FundingStreamPeriodCode incorrect");
            Assert.AreEqual(3, row.CalcPolicyVersion, "FSP Pay Calc Policy - CalcPolicyVersion incorrect");
            Assert.AreEqual("Contract Allocation Duration", row.PaymentCappingPeriod, "FSP Pay Calc Policy - PaymentCappingPeriod incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodPayCalcPolicyReader_Json_ShouldReadAllPublishedRows()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Pay Calc Policy");
            FundingStreamPeriodPayCalcPolicyReader reader = new FundingStreamPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            Assert.AreEqual(74, rows.Count(), "Unexpected number of rows returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodPayCalcPolicyReader_Json_ShouldReadArbitraryRowValues()
        {
            // arrange
            _jsonReader = GetJsonWorkbookReader();
            IWorksheetReader worksheetReader = _jsonReader.WorksheetReader("FSP Pay Calc Policy");
            FundingStreamPeriodPayCalcPolicyReader reader = new FundingStreamPeriodPayCalcPolicyReader();

            // act
            IEnumerable<FundingStreamPeriodPayCalcPolicySheetType> rows = reader.ReadConfig(worksheetReader);

            // assert
            FundingStreamPeriodPayCalcPolicySheetType row = rows.SingleOrDefault(st => st.FundingStreamPeriodCode == "AEB-AS1920" && st.CalcPolicyVersion == 3);

            Assert.IsNotNull(row, "Row not found");
            Assert.AreEqual("AEB-AS1920", row.FundingStreamPeriodCode, "FSP Pay Calc Policy - FundingStreamPeriodCode incorrect");
            Assert.AreEqual(3, row.CalcPolicyVersion, "FSP Pay Calc Policy - CalcPolicyVersion incorrect");
            Assert.AreEqual("Contract Allocation Duration", row.PaymentCappingPeriod, "FSP Pay Calc Policy - PaymentCappingPeriod incorrect");
        }
    }
}
