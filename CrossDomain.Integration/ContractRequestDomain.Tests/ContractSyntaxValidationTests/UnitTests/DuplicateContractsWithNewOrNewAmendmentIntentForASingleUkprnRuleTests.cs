namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnFailuresWhenFileContainsContractsWithTheSameUkprnAndIntentIsNewForAll()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "New";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsTrue(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnFailuresWhenFileContainsContractsWithTheSameUkprnAndIntentIsNewForOnJustOne()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "New";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsTrue(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnNoFailuresWhenFileContainsOneContractAndIntentIsNew()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            
            contractSheetType.row = new []{ contractSheetType.row[0]};
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsFalse(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnFailuresWhenFileContainsContractsWithTheSameUkprnAndIntentIsNewAmendmentForAll()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsTrue(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnFailuresWhenFileContainsContractsWithTheSameUkprnAndIntentIsNewAmendmentForJustOne()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsTrue(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnNoFailuresWhenFileContainsOneContractAndIntentIsNewAmendment()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");

            contractSheetType.row = new[] { contractSheetType.row[0] };
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsFalse(errorInfos.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule_ShouldReturnFailuresWhenFileContainsContractsWithTheSameUkprnAndIntentIsNewAmendmentAndIsNew()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";

            // act
            List<errorInfo> errorInfos = DuplicateContractsWithNewOrNewAmendmentIntentForASingleUkprnRule.GetFailuresForItem(spreadsheetData);

            // assert
            Assert.IsTrue(errorInfos.Any());
        }

        private static dataLoadResults GetDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 04022016141822 v2_10017455.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }
    }
}
