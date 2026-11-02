namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FileNameValidationTests
    {
        private static readonly Mock<IFundingTypeFundingPeriodRepository> MockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
        private static readonly Mock<IDateProvider> MockDate = new Mock<IDateProvider>();
        private readonly ContractBulkUploadFileLevelValidation _validator = new ContractBulkUploadFileLevelValidation(MockRepository.Object, MockDate.Object, Mock.Of<IFundingAllocationReleaseRepository>(), Mock.Of<ILogger>());
        private dataLoadResults data;

        [TestInitialize]
        public void GetData()
        {
            data = (dataLoadResults)XmlSerialization.DeserializeXml(XDocument.Load("Resources\\FileLevelValidationRequest.xml").Root, typeof(dataLoadResults));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesA_ValidFileName()
        {
            const string filename = "ASTRO AY 1516 12012015202601 file_1a.xlsx";
            Assert.IsTrue(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileName_WithAnExtraSpace()
        {
            const string filename = "MAIN AY 1516 12012015202601 file 1a.xlsx";
            Assert.IsFalse(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_InvalidFileName_MissingElement()
        {
            const string filename = "MAIN AY 1516 file_1a.xlsx";
            Assert.IsFalse(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileName_WithMissingFreeText()
        {
            const string filename = "MAIN AY 1516 12012015202601 .xlsx";
            Assert.IsFalse(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesA_ValidFileName_WithACorrectFundingType()
        {
            const string filename = "24+LOANS AY 1516 12012015202601 file 1a.xlsx";
            Assert.IsTrue(_validator.FSR_005a_ValidateFileNameFundingType(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileName_WithAnIncorrectFundingType()
        {
            const string filename = "AGE AY 1516 12012015202601 file 1a.xlsx";
            Assert.IsFalse(_validator.FSR_005a_ValidateFileNameFundingType(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesA_ValidFileName_WithACorrectPeriodType()
        {
            const string filename = "MAIN AY 1516 12012015202601 file1a.xlsx";
            Assert.IsTrue(_validator.FSR_005b_ValidateFileNamePeriodType(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileNameIncorrectPeriodTypeTest()
        {
            const string filename = "MAIN YY 1516 12012015202601 file 1a.xlsx";
            Assert.IsFalse(_validator.FSR_005b_ValidateFileNamePeriodType(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesA_ValidFileName_WithACorrectPeriod()
        {
            const string filename = "MAIN AY 1516 12012015202601 file 1a.xlsx";
            Assert.IsTrue(_validator.FSR_005c_ValidateFileNamePeriod(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileName_WithAnIncorrectPeriod()
        {
            const string filename = "MAIN AY 1999 12012015202601 file 1a.xlsx";
            Assert.IsFalse(_validator.FSR_005c_ValidateFileNamePeriod(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesA_ValidFileName_WithACorrectDateFormat()
        {
            const string filename = "MAIN AY 1516 12012015202601 file1a.xlsx";
            Assert.IsTrue(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Ensure_ValidateFileName_ValidatesAn_InvalidFileName_WithAnIncorrectDateFormat()
        {
            const string filename = "MAIN AY 1516 12012015 file 1a.xlsx";
            Assert.IsFalse(_validator.FSR_002_ValidateFileName(filename, data.workbook.First(c => c.name == "Control Sheet").row.First()));
        }
    }
}
