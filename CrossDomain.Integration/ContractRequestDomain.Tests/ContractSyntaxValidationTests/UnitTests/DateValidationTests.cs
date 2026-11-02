namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DateValidationTests
    {
        private IContractSyntaxValidation _validator;
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            _validator = GetContainer().Resolve<IContractSyntaxValidation>();
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            {
                _data =  new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ValidFileSyntaxValidationTest()
        {
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidAllocationDatesTest()
        {
            var temp = _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.AllocationsStartDate).Value;
            //set start date to old end date
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.AllocationsStartDate).Value =
                   _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.AllocationsEndDate).Value;
            //Set end date to old start date 
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.AllocationsEndDate).Value = temp;

            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value == ErrorMessages.EndDateBeforeStartDateErrorMessage));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidContractDatesTest()
        {
            var temp = _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value;
            //set start date to old end date
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractStartDate).Value =
                   _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractEndDate).Value;
            //Set end date to old start date 
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.ContractEndDate).Value = temp;

            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value == ErrorMessages.EndDateBeforeStartDateErrorMessage));
        }

        private IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();

            IWindsorContainer container =
                new WindsorContainer()
                    .Install(new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(factory))
                    .Register(Component.For<IFundingTypeFundingPeriodRepository>()
                        .Instance(Mock.Of<IFundingTypeFundingPeriodRepository>()).IsDefault())
                    .Register(Component.For<IFundingAllocationReleaseRepository>()
                        .Instance(Mock.Of<IFundingAllocationReleaseRepository>()).IsDefault());

            container.BeginScope();

            return container;
        }
    }
}
