namespace ContractRequestDomain.Tests
{
    extern alias RequestDomainDS;
    extern alias CSICommon;
    using System;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FileValidationIntegrationTests
    {
        private ContractBulkUploadFileLevelValidation _fileValidation;
        private dataLoadResults _testData;
        private readonly Mock<IFundingTypeFundingPeriodRepository> _mockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
        //private readonly Mock<IDate> _mockDate = new Mock<IDate>();

        [TestInitialize]
        public void GetData()
        {
            _mockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                           .Returns((DateTime?) null);
            //_mockDate.Setup(m => m.GetCalculationDate()).Returns(DateTime.Now);

            _fileValidation = new ContractBulkUploadFileLevelValidation(_mockRepository.Object, new DateProvider(), Mock.Of<IFundingAllocationReleaseRepository>(), Mock.Of<ILogger>());
            XDocument xmlFile = XDocument.Load("Resources\\FileLevelValidationRequest.xml");
            _testData =
                ((dataLoadResults)
                    XmlSerialization.DeserializeXml(xmlFile.Root, typeof(dataLoadResults)));
        }


        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_AnEntireFileCanBeValidated_ValidFile()
        {
            Assert.IsTrue(_fileValidation.Validate(_testData, ConnectionInfo.CreateDefault()));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Ensure_AnEntireFileCanBeValidated_InvalidFileName()
        {
            _testData.fileName = "adfjlkqjeroiqjweofq.xlsx";

            Assert.IsFalse(_fileValidation.Validate(_testData, ConnectionInfo.CreateDefault()));
            Assert.IsTrue(_testData.error.Any(e => e.Value == "File name is not as expected"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldValidateUpdateContractAmentdment_FailValidationRuleUDC017b()
        {
            //Modify test data to make file an update amendment file for rule UDC017b
            _testData.workbook[2].row[0].cell[1].Value = "MAIN-123";
            _testData.workbook[1].row[0].cell[1].Value = "MAIN-124";
            _testData.workbook[2].row[0].cell[5].Value = "Update Draft Amendment";
            bool isValid = _fileValidation.Validate(_testData, ConnectionInfo.CreateDefault());
            var errors = _fileValidation.Errors;

            Assert.IsFalse(isValid);
            Assert.IsTrue(
                errors.Select(e => e.Value.Contains(ErrorMessages.ContractAllocationMustHaveRelatedContractBRule))
                    .FirstOrDefault());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractBulkUploadFileLevelValidation_Should_FailIfActivityCloseDateIsInPast()
        {
            // arrange
            DateTime fakeTodayDate = new DateTime(2017, 2, 1);
            _mockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                           .Returns(fakeTodayDate.Subtract(new TimeSpan(1, 0, 0, 0)));

            // act
            bool isValid = _fileValidation.Validate(_testData, ConnectionInfo.CreateDefault());
            var errors = _fileValidation.Errors;

            // assert
            Assert.IsFalse(isValid);
            Assert.IsTrue(errors.Any(e => e.Value.Contains(ErrorMessages.ContractingActivityHasClosedForFundingTypePeriod)));
        }
    }
}
