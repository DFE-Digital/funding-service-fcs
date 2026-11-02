using UnitTests.Common;
namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DataTypeAndLengthValidationTests
    {
        private IContractSyntaxValidation _validator;
        private dataLoadResults _data;

        private const string DataTypeErrorMessages = "is not as per expected data type as specified in 'Bulk Import File Specification'";

        [TestInitialize]
        public void GetData()
        {
            _validator = GetContainer().Resolve<IContractSyntaxValidation>();
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            {
                _data = new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataTypesIntTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Ukprn).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(DataTypeErrorMessages)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_DecimalInVolume_ShouldAddErrorWithCorrectMessage()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "1.01";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains("Volume must be a whole number")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_NegativeDecimalInVolume_ShouldAddErrorWithCorrectMessage()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "-12.5";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains("Volume must be a whole number")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_IntegerInVolume_ShouldNotAddError()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "1234";
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_NegativeIntegerInVolume_ShouldNotAddError()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "-389";
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_IntegerWithDecimalPointInVolume_ShouldNotAddError()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "2983.0";
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_ValidateFile_NegativeIntegerWithDecimalPointInVolume_ShouldNotAddError()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Volume).Value = "-28.0";
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataTypesDateTimeTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(DataTypeErrorMessages)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataLengthExceedsTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value = "22/01/20151";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains("is not as per expected length as specified in 'Bulk Import File Specification'")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataLengthInsufficentTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value = "22/01/15";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(" is not as per expected length as specified in 'Bulk Import File Specification'")));
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataContentContractAmendmentTypeTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.AmendmentType).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(DataTypeErrorMessages)));
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataContentContractCrmIntentTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(ErrorMessages.CRMIntentInvalidErrorMessage)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataContentDeliverableValueTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.Value).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(DataTypeErrorMessages)));
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataContentAllocationCrmIntentTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(ErrorMessages.CRMIntentInvalidErrorMessage)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidDataContentDeliverableCrmIntentTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains(ErrorMessages.CRMIntentInvalidErrorMessage)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ShouldValidateFile_WhereContractStartAndEndDateAreNull()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value = string.Empty;
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractEndDate).Value = string.Empty;
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        private IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();

            IWindsorContainer container =
                new WindsorContainer().Install(
                        new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(factory))
                    .Register(Component.For<IFundingTypeFundingPeriodRepository>()
                        .Instance(Mock.Of<IFundingTypeFundingPeriodRepository>()).IsDefault())
                    .Register(Component.For<IFundingAllocationReleaseRepository>()
                        .Instance(Mock.Of<IFundingAllocationReleaseRepository>()).IsDefault());

            container.BeginScope();
            return container;
        }
    }
}
