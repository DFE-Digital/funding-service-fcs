namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using global::UnitTests.Common;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class MandatoryItemsValidationTests
    {
        private IContractSyntaxValidation _validator;
        private dataLoadResults _data;

        [TestInitialize]
        public void GetData()
        {
            _validator = GetContainer().Resolve<IContractSyntaxValidation>();
            using (
               TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            { 
                _data = new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InvalidMandatoryItemsTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractsSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).columnName = "Invalid";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value.Contains("is a mandatory field and therefore can not be null as specified in 'Bulk Import File Specification'")));
        }

        private IWindsorContainer GetContainer()
        {
            IWindsorContainer container =
                new WindsorContainer()
                    .Install(
                        new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(
                            new LoggerFactory()))
                    .Register(Component.For<IFundingTypeFundingPeriodRepository>()
                        .Instance(Mock.Of<IFundingTypeFundingPeriodRepository>()).IsDefault())
                    .Register(Component.For<IFundingAllocationReleaseRepository>()
                        .Instance(Mock.Of<IFundingAllocationReleaseRepository>()).IsDefault());
            container.BeginScope();

            return container;
        }
    }
}
