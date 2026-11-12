namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    extern alias RequestDomainDS;
    extern alias CSICommon;

    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common.Utils;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class PeriodTypeValidationTests
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
        public void Ensure_ValidatePeriodTypeCode_ValidatesA_ValidPeriodType()
        {
            Assert.IsTrue(_validator.FSR_007_ValidatePeriodTypeCode(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidatePeriodTypeCode_ValidatesAn_InvalidPeriodType()
        {
            _data.workbook.First(c => c.name == "Control Sheet").row.First().cell.First(c => c.columnName == "PeriodTypeCode").Value = "Invalid";
            Assert.IsFalse(_validator.FSR_007_ValidatePeriodTypeCode(_data.workbook.First(c => c.name == "Control Sheet"), _data.ReferenceData.FundingConfiguration));
        }
    }
}
