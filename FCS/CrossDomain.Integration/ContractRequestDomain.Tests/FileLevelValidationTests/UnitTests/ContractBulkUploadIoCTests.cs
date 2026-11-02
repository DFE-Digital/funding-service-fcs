namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractBulkUploadIoCTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractBulkUploadFileLevelValidation_ShouldBeResolvedByIoC()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(
                    new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(new LoggerFactory()));
            container.BeginScope();

            // act
            IContractBulkUploadFileLevelValidation validator =
                container.Resolve<IContractBulkUploadFileLevelValidation>();

            Assert.IsNotNull(validator, "ContractBulkUploadFileLevelValidation could not be resolved from bulk upload.");
        }
    }
}