namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class TypeCombinationValidationTests
    {
        private static readonly Mock<IFundingTypeFundingPeriodRepository> MockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
        private static readonly Mock<IDateProvider> MockDate = new Mock<IDateProvider>();
        private readonly ContractBulkUploadFileLevelValidation _validator = new ContractBulkUploadFileLevelValidation(MockRepository.Object, MockDate.Object, Mock.Of<IFundingAllocationReleaseRepository>(), Mock.Of<ILogger>());
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            _data = (dataLoadResults)XmlSerialization.DeserializeXml(XDocument.Load("Resources\\FileLevelValidationRequest.xml").Root, typeof(dataLoadResults));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateTypeCombination_ValidatesA_ValidTypeCombination()
        {
            Assert.IsTrue(_validator.FSR_009_ValidateTypeCombination(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateTypeCombination_ValidatesAn_InvalidTypeCombination()
        {
            _data.workbook.First(c => c.name == "Control Sheet").row.First().cell.First(c => c.columnName == "FundingTypeCode").Value = "Invalid";
            _data.workbook.First(c => c.name == "Control Sheet").row.First().cell.First(c => c.columnName == "PeriodTypeCode").Value = "Invalid";
            _data.workbook.First(c => c.name == "Control Sheet").row.First().cell.First(c => c.columnName == "Period").Value = "Invalid";
            Assert.IsFalse(_validator.FSR_009_ValidateTypeCombination(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }
    }
}
