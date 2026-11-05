namespace ContractRequestDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class FileValidationFscEnrichmentTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenFileStructureIsInvalid_CopiesValidationErrorsAndStops()
        {
            var expectedError = new errorInfo { Value = "Invalid file structure" };
            var validator = new Mock<IContractBulkUploadFileLevelValidation>();
            validator.Setup(x => x.FSR_004_ValidateFileStructure(It.IsAny<dataLoadResults>())).Returns(false);
            validator.SetupGet(x => x.Errors).Returns(new List<errorInfo> { expectedError });

            var input = new dataLoadResults { batchId = "batch" };
            var enrichment = new FileValidationFscEnrichment(Mock.Of<ILogger>(), validator.Object);

            enrichment.Enrich(input);

            Assert.AreEqual(1, input.error.Length);
            Assert.AreSame(expectedError, input.error[0]);
            Assert.IsNull(input.ReferenceData);
            validator.Verify(x => x.FSR_004_ValidateFileStructure(input), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Enrich_WhenFileStructureIsValid_FetchesReferenceDataOnceAndUsesCachedResult()
        {
            var period = Guid.NewGuid().ToString("N");
            var periodType = Guid.NewGuid().ToString("N");
            var fundingType = Guid.NewGuid().ToString("N");
            var referenceData = new FundingConfigurationType();
            var fetchCount = 0;
            var validator = new Mock<IContractBulkUploadFileLevelValidation>();
            validator.Setup(x => x.FSR_004_ValidateFileStructure(It.IsAny<dataLoadResults>())).Returns(true);

            var enrichment = new FileValidationFscEnrichment(
                Mock.Of<ILogger>(),
                validator.Object,
                (batchId, requestedPeriod, requestedPeriodType, requestedFundingType) =>
                {
                    Assert.AreEqual(period, requestedPeriod);
                    Assert.AreEqual(periodType, requestedPeriodType);
                    Assert.AreEqual(fundingType, requestedFundingType);
                    fetchCount++;
                    return referenceData;
                });
            var firstInput = CreateValidFile("first", period, periodType, fundingType);
            var secondInput = CreateValidFile("second", period, periodType, fundingType);

            enrichment.Enrich(firstInput);
            enrichment.Enrich(secondInput);

            Assert.AreEqual(1, fetchCount);
            Assert.AreSame(referenceData, firstInput.ReferenceData.FundingConfiguration);
            Assert.AreSame(referenceData, secondInput.ReferenceData.FundingConfiguration);
            Assert.IsNull(firstInput.error);
            Assert.IsNull(secondInput.error);
        }

        private static dataLoadResults CreateValidFile(string batchId, string period, string periodType, string fundingType)
        {
            return new dataLoadResults
            {
                batchId = batchId,
                workbook = new[]
                {
                    new sheetType
                    {
                        name = ContractBulkUpload.ControlSheetFieldName,
                        row = new[]
                        {
                            new rowType
                            {
                                cell = new[]
                                {
                                    new cellType { columnName = ContractBulkUpload.ControlSheetPeriod, Value = period },
                                    new cellType { columnName = ContractBulkUpload.ControlSheetPeriodTypeCode, Value = periodType },
                                    new cellType { columnName = ContractBulkUpload.ControlSheetFundingTypeCode, Value = fundingType }
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}
