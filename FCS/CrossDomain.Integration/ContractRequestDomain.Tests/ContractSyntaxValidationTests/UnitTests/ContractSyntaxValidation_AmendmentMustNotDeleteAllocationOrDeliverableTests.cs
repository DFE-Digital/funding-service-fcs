namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using global::UnitTests.Common;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.DataStore;
    using SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractSyntaxValidation_AmendmentMustNotDeleteAllocationOrDeliverableTests
    {
        private IContractSyntaxValidation _validator;
        private dataLoadResults _data;

        [TestInitialize]
        public void TestInitialize()
        {
            Mock<IFundingTypeFundingPeriodRepository> mockRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            mockRepository.Setup(m => m.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(It.IsAny<string>(), It.IsAny<string>())).Returns(false);

            IWindsorContainer container = GetContainer();
            container.Register(Component.For<IFundingTypeFundingPeriodRepository>().Instance(mockRepository.Object).IsDefault());
            container.Register(Component.For<IFundingAllocationReleaseRepository>().Instance(Mock.Of<IFundingAllocationReleaseRepository>()).IsDefault());
            container.BeginScope();

            _validator = container.Resolve<IContractSyntaxValidation>();

            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Amendment.xlsx"))
            {
                _data = new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");  
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_EnsureNoFalseFailuresForDeleteValidationTest()
        {
            Assert.IsTrue(_validator.ValidateFile(_data));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_AttemptToDeleteAnAllocationTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.First().cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Delete Draft";
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value == ErrorMessages.NoDeleteOnApprovedContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_AttemptToDeleteADeliverableTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.ForEach(row => row.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Delete Draft");
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value == ErrorMessages.NoDeleteOnApprovedContract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_AttemptToDeleteAnAllocationAndDeliverableTest()
        {
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractAllocationSheetFieldName).row.ForEach(row => row.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Delete Draft");
            _data.workbook.First(w => w.name == ContractBulkUpload.ContractDeliverableSheetFieldName).row.ForEach(row => row.cell.First(c => c.columnName == ContractBulkUpload.CrmIntent).Value = "Delete Draft");
            Assert.IsFalse(_validator.ValidateFile(_data));
            Assert.IsTrue(_validator.Errors.Any(e => e.Value == ErrorMessages.NoDeleteOnApprovedContract));
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();

            return
                new WindsorContainer().Install(
                    new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(factory));
        }
    }
}
