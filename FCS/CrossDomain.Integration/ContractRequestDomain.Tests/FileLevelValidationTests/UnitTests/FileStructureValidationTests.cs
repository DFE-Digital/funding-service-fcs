namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.ContractRequestDomain.Common.Utils;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FileStructureValidationTests
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
        public void Ensure_ValidateFileStructure_ValidatesA_ValidStructureTest()
        {
            Assert.IsTrue(_validator.FSR_004_ValidateFileStructure(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileStructure_ValidatesAn_InvalidStructure_WithNoControlSheet()
        {
            _data.workbook.First(w => w.name == "Control Sheet").name = "Invalid";
            Assert.IsFalse(_validator.FSR_004_ValidateFileStructure(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileStructure_ValidatesAn_InvalidStructure_WithNoContractSheet()
        {
            _data.workbook.First(w => w.name == "Contract").name = "Invalid";
            Assert.IsFalse(_validator.FSR_004_ValidateFileStructure(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileStructure_ValidatesAn_InvalidStructure_WithNoContractAllocationsSheet()
        {
            _data.workbook.First(w => w.name == "Contract Allocation").name = "Invalid";
            Assert.IsFalse(_validator.FSR_004_ValidateFileStructure(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileStructure_ValidatesAn_InvalidStructure_WithNoDeliverablesSheet()
        {
            _data.workbook.First(w => w.name == "Deliverable").name = "Invalid";
            Assert.IsFalse(_validator.FSR_004_ValidateFileStructure(_data));
        }
    }
}
