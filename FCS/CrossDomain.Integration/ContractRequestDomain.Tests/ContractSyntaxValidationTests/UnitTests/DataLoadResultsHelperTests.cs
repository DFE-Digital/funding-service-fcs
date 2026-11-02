namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class DataLoadResultsHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsHelper_ShouldGetTheFundingType()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();

            // act
            string fundingType = DataLoadResultsHelper.GetFundingType(spreadsheetData);

            // assert
            Assert.AreEqual("MAIN", fundingType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsHelper_ShouldGetTheFundingTypeWhenControlSheetIsNotTheFirst()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResultsWhereControlSheetIsNotTheFirst();

            // act
            string fundingType = DataLoadResultsHelper.GetFundingType(spreadsheetData);

            // assert
            Assert.AreEqual("MAIN", fundingType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsHelper_ShouldGetFundingPeriodWhereControlSheetIsNotTheFirst()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResultsWhereControlSheetIsNotTheFirst();

            // act
            string fundingType = DataLoadResultsHelper.GetFundingPeriod(spreadsheetData);

            // assert
            Assert.AreEqual("AY1516", fundingType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DataLoadResultsHelper_ShouldGetFundingPeriod()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();

            // act
            string fundingType = DataLoadResultsHelper.GetFundingPeriod(spreadsheetData);

            // assert
            Assert.AreEqual("AY1516", fundingType);
        }

        private dataLoadResults GetDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 04022016141822 v2_10017455.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        private dataLoadResults GetDataLoadResultsWhereControlSheetIsNotTheFirst()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 09042015143000 UpdateDraftContractUDC000_1.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }
    }
}
