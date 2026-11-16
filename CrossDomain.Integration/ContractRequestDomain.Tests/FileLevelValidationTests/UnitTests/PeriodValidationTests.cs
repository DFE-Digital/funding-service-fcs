namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    extern alias RequestDomainDS;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PeriodValidationTests
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
        public void Ensure_ValidatePeriod_ValidatesAValidPeriod()
        {
            Assert.IsTrue(_validator.FSR_008_ValidatePeriod(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidatePeriod_ValidatesAnInvalidPeriod()
        {
            _data.workbook.First(c => c.name == "Control Sheet").row.First().cell.First(c => c.columnName == "Period").Value = "Invalid";
            Assert.IsFalse(_validator.FSR_008_ValidatePeriod(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }
    }
}
