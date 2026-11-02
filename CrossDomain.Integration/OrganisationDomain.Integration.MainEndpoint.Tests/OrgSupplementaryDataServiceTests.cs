namespace OrganisationDomain.Integration.MainEndpoint.Tests
{
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using Implementation.Services;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class OrgSupplementaryDataServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrgSupplementaryDataService_ShouldResolveRealImplementationW()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealUkrlpService"] = "true";
            IWindsorContainer container = GetContainer();

            // act and assert
            IOrgSupplementaryDataService orgSupplementaryDataService = container.Resolve<IOrgSupplementaryDataService>();
            Assert.IsTrue(orgSupplementaryDataService is OrgSupplementaryDataService);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrgSupplementaryDataService_ShouldResolveTestImplementationW()
        {
            // arrange
            ConfigurationManager.AppSettings["UseRealUkrlpService"] = "false";
            IWindsorContainer container = GetContainer();

            // act and assert
            IOrgSupplementaryDataService orgSupplementaryDataService = container.Resolve<IOrgSupplementaryDataService>();
            Assert.IsTrue(orgSupplementaryDataService is OrgSupplementaryDataServiceTestImpl);
        }

        private IWindsorContainer GetContainer()
        {
            var container = OrganisationDomain.Integration.MainEndpoint.Ioc.Bootstrapper.CreateContainer(new LoggerFactory());
            return container;
        }
    }
}
