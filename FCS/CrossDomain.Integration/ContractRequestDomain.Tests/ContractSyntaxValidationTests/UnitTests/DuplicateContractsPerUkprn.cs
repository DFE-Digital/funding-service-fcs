namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using System.Linq;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;

    [TestClass]
    public class DuplicateContractsPerUkprn
    {
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            {
                _data = new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidFile_PassesDuplicateUkprnValidation()
        {
            Assert.IsFalse(DuplicateContractsForASingleUkprnRule.GetFailuresForItem(_data).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_DuplicatedContracts_WithTheSameUkprn_FailValidation()
        {
            var contractSheet = _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName);
            var contractsRows= contractSheet.row.ToList();
            contractsRows.Add(contractsRows[0]);

            contractSheet.row = contractsRows.ToArray();
            var errors = DuplicateContractsForASingleUkprnRule.GetFailuresForItem(_data);
            Assert.IsTrue(errors.Any());
        }
    }
}
