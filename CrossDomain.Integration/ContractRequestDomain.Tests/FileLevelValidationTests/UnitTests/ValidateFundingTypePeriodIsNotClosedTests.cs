namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    extern alias RequestDomainDS;
    extern alias CSICommon;
    using System;
    using System.Linq;
    using System.Xml.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ValidateFundingTypePeriodIsNotClosedTests
    {
        private static readonly Mock<IFundingTypeFundingPeriodRepository> MockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
        private static readonly Mock<IDateProvider> MockDate = new Mock<IDateProvider>();
        private readonly ContractBulkUploadFileLevelValidation _validator = new ContractBulkUploadFileLevelValidation(MockRepository.Object, MockDate.Object, Mock.Of<IFundingAllocationReleaseRepository>(), Mock.Of<ILogger>());
        private dataLoadResults _data;

        [TestInitialize]
        public void Setup()
        {
            _data = (dataLoadResults)XmlSerialization.DeserializeXml(XDocument.Load("Resources\\FileLevelValidationRequest.xml").Root, typeof(dataLoadResults));
            MockDate.Setup(m => m.GetDate(It.IsAny<ConnectionInfo>())).Returns(new DateTime(2017, 1, 1, 15, 23, 12));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractBulkUploadFileLevelValidation_ValidateFundingTypePeriodIsNotClosed_ActivityCloseDateIsToday_ShouldPass()
        {
            // arrange
            MockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                          .Returns(new DateTime(2017, 1, 1, 0, 0, 0));

            // act
            _validator.FSR_011_ValidateFundingTypePeriodIsNotClosed(_data.GetSheet("Control Sheet"), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(_validator.Errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractBulkUploadFileLevelValidation_ValidateFundingTypePeriodIsNotClosed_ActivityCloseDateIsInFuture_ShouldPass()
        {
            // arrange
            MockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                          .Returns(new DateTime(2017, 2, 1, 0, 0, 0));

            // act
            _validator.FSR_011_ValidateFundingTypePeriodIsNotClosed(_data.GetSheet("Control Sheet"), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(_validator.Errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractBulkUploadFileLevelValidation_ValidateFundingTypePeriodIsNotClosed_ActivityCloseDateIsNotSet_ShouldPass()
        {
            // arrange
            MockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                          .Returns((DateTime?)null);

            // act
            _validator.FSR_011_ValidateFundingTypePeriodIsNotClosed(_data.GetSheet("Control Sheet"), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(_validator.Errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractBulkUploadFileLevelValidation_ValidateFundingTypePeriodIsNotClosed_ActivityCloseDateIsInPast_ShouldFail()
        {
            // arrange
            MockRepository.Setup(m => m.GetActivityCloseDate(It.IsAny<string>(), It.IsAny<string>()))
                          .Returns(new DateTime(2016, 12, 25, 0, 0, 0));

            // act
            _validator.FSR_011_ValidateFundingTypePeriodIsNotClosed(_data.GetSheet("Control Sheet"), ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(ErrorMessages.ContractingActivityHasClosedForFundingTypePeriod)));
        }
    }
}