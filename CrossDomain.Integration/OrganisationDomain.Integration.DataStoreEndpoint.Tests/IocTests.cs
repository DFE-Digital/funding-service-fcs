namespace OrganisationDomain.Integration.DataStoreEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Ioc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Castle.Windsor;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class IocTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetUpdatedOrganisationsHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new ComponentInstaller(new LoggerFactory()))
                .Register(Component.For<GetUpdatedOrganisationsHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<GetUpdatedOrganisationsHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SaveUpdatedOrganisationHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new ComponentInstaller(new LoggerFactory()))
                .Register(Component.For<SaveUpdatedOrganisationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<SaveUpdatedOrganisationHandler>();
        }
    }
}
