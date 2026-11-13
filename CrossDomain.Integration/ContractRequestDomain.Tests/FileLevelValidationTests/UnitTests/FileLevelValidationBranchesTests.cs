extern alias RequestDomainDS;

namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using IFundingAllocationReleaseRepository = RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories.IFundingAllocationReleaseRepository;
    using IFundingTypeFundingPeriodRepository = RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories.IFundingTypeFundingPeriodRepository;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FileLevelValidationBranchesTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ValidateFileStructure_RequiresAllFourWorkbookSheets()
        {
            var validator = CreateValidator();
            var file = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType { name = ContractBulkUpload.ControlSheetFieldName },
                    new sheetType { name = ContractBulkUpload.ContractsSheetFieldName },
                    new sheetType { name = ContractBulkUpload.ContractAllocationSheetFieldName }
                }
            };

            Assert.IsFalse(validator.FSR_004_ValidateFileStructure(file));
            Assert.IsTrue(validator.Errors.Any());

            file.workbook = file.workbook.Concat(new[]
            {
                new sheetType { name = ContractBulkUpload.ContractDeliverableSheetFieldName }
            }).ToArray();
            Assert.IsTrue(validator.FSR_004_ValidateFileStructure(file));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FileNameValidations_AcceptMatchingPartsAndRejectMismatches()
        {
            var validator = CreateValidator();
            var controlRow = new rowType
            {
                cell = new[]
                {
                    new cellType { columnName = ContractBulkUpload.ControlSheetFundingTypeCode, Value = "DAS" },
                    new cellType { columnName = ContractBulkUpload.ControlSheetPeriodTypeCode, Value = "AY" },
                    new cellType { columnName = ContractBulkUpload.ControlSheetPeriod, Value = "2526" }
                }
            };
            const string validName = "DAS AY 2526 26102026120000 upload.xlsx";

            Assert.IsTrue(validator.FSR_001_ValidateFileType(validName));
            Assert.IsTrue(validator.FSR_002_ValidateFileName(validName, controlRow));
            Assert.IsTrue(validator.FSR_005a_ValidateFileNameFundingType(validName, controlRow));
            Assert.IsTrue(validator.FSR_005b_ValidateFileNamePeriodType(validName, controlRow));
            Assert.IsTrue(validator.FSR_005c_ValidateFileNamePeriod(validName, controlRow));

            Assert.IsFalse(validator.FSR_001_ValidateFileType("upload.xls"));
            Assert.IsFalse(validator.FSR_002_ValidateFileName("invalid name.xlsx", controlRow));
            Assert.IsFalse(validator.FSR_005a_ValidateFileNameFundingType("OTHER AY 2526 26102026120000 upload.xlsx", controlRow));
            Assert.IsFalse(validator.FSR_005b_ValidateFileNamePeriodType("DAS OTHER 2526 26102026120000 upload.xlsx", controlRow));
            Assert.IsFalse(validator.FSR_005c_ValidateFileNamePeriod("DAS AY OTHER 26102026120000 upload.xlsx", controlRow));
            Assert.AreEqual(5, validator.Errors.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateContractDataExists_RejectsNullOrEmptyRows()
        {
            var validator = CreateValidator();

            Assert.IsFalse(validator.ValidateContractDataExists(new sheetType { row = null }));
            Assert.IsFalse(validator.ValidateContractDataExists(new sheetType { row = new rowType[0] }));
            Assert.IsTrue(validator.ValidateContractDataExists(new sheetType { row = new[] { new rowType() } }));
            Assert.AreEqual(2, validator.Errors.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidateFundingAllocationInProgress_AddsErrorOnlyWhileReleaseIsRunning()
        {
            var releaseRepository = new Mock<IFundingAllocationReleaseRepository>();
            var validator = CreateValidator(releaseRepository.Object);
            var controlSheet = new sheetType
            {
                row = new[]
                {
                    new rowType
                    {
                        cell = new[]
                        {
                            new cellType { columnName = ContractBulkUpload.ControlSheetFundingTypeCode, Value = "DAS" },
                            new cellType { columnName = ContractBulkUpload.ControlSheetPeriodTypeCode, Value = "AY" },
                            new cellType { columnName = ContractBulkUpload.ControlSheetPeriod, Value = "2526" }
                        }
                    }
                }
            };
            var connectionInfo = ConnectionInfo.CreateDefault();

            releaseRepository.Setup(x => x.IsReleaseInProgress("DAS", "AY2526", connectionInfo)).Returns(false);
            validator.FSR_012_ValidateFundingAllocationInProgress(controlSheet, connectionInfo);
            Assert.AreEqual(0, validator.Errors.Count);

            releaseRepository.Setup(x => x.IsReleaseInProgress("DAS", "AY2526", connectionInfo)).Returns(true);
            validator.FSR_012_ValidateFundingAllocationInProgress(controlSheet, connectionInfo);

            Assert.AreEqual(1, validator.Errors.Count);
            Assert.IsTrue(validator.Errors[0].Value.Contains("Release of funding allocations"));
        }

        private static ContractBulkUploadFileLevelValidation CreateValidator(
            IFundingAllocationReleaseRepository releaseRepository = null)
        {
            return new ContractBulkUploadFileLevelValidation(
                Mock.Of<IFundingTypeFundingPeriodRepository>(),
                Mock.Of<IDateProvider>(),
                releaseRepository ?? Mock.Of<IFundingAllocationReleaseRepository>(),
                Mock.Of<ILogger>());
        }
    }
}
