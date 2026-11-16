namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    extern alias RequestDomainDS;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FileTypeValidationTests
    {
        private static readonly Mock<IFundingTypeFundingPeriodRepository> MockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
        private static readonly Mock<IDateProvider> MockDate = new Mock<IDateProvider>();
        private readonly ContractBulkUploadFileLevelValidation _validator = new ContractBulkUploadFileLevelValidation(MockRepository.Object, MockDate.Object, Mock.Of<IFundingAllocationReleaseRepository>(), Mock.Of<ILogger>());

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileType_ValidatesAValidFileType()
        {
            const string filename = "test.xlsx";
            Assert.IsTrue(_validator.FSR_001_ValidateFileType(filename));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileType_ValidatesAnInvalidFileTypePdf()
        {
            const string filename = "test.pdf";
            Assert.IsFalse(_validator.FSR_001_ValidateFileType(filename));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileType_ValidatesAnInvalidFileTypeDocx()
        {
            const string filename = "test.docx";
            Assert.IsFalse(_validator.FSR_001_ValidateFileType(filename));
        }
    }
}
