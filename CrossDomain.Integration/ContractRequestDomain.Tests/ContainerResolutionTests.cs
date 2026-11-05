namespace ContractRequestDomain.Tests
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;

    // Guards against test seams (extra constructors) changing how Windsor builds the production types.
    [TestClass]
    public class ContainerResolutionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FileValidationFscEnrichment_ResolvesFromContainerUsingRegisteredDependencies()
        {
            using (var container = new WindsorContainer())
            {
                container.Register(
                    Component.For<ILogger>().Instance(Mock.Of<ILogger>()),
                    Component.For<IContractBulkUploadFileLevelValidation>().Instance(Mock.Of<IContractBulkUploadFileLevelValidation>()),
                    Component.For<IFileValidationFscEnrichment>().ImplementedBy<FileValidationFscEnrichment>().LifestyleTransient());

                var resolved = container.Resolve<IFileValidationFscEnrichment>();

                Assert.IsInstanceOfType(resolved, typeof(FileValidationFscEnrichment));
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Office365StorageWrapper_ResolvesFromContainerWithoutExtraRegistrations()
        {
            using (var container = new WindsorContainer())
            {
                container.Register(Component.For<IOffice365Adapter>().ImplementedBy<Office365StorageWrapper>().LifestyleTransient());

                var resolved = container.Resolve<IOffice365Adapter>();

                Assert.IsInstanceOfType(resolved, typeof(Office365StorageWrapper));
            }
        }
    }
}
