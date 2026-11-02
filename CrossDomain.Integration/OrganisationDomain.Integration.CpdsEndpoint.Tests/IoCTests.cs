namespace OrganisationDomain.Integration.CpdsEndpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Implementation.BusinessLogic;
    using Ioc;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class IoCTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IoCTest_ShouldResolveGetOrganisationDetailsHandler()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new ComponentInstaller(new LoggerFactory()))
                .Register(Component.For<GetOrganisationDetailsHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<GetOrganisationDetailsHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IoCTest_ShouldResolveGetProviderSummaryHandler()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new ComponentInstaller(new LoggerFactory()))
                .Register(Component.For<GetProviderSummaryHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<GetProviderSummaryHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IoCTest_ShouldResolveICpdsSummaryRetriever()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new ComponentInstaller(new LoggerFactory()));

            container.BeginScope();

            // act
            container.Resolve<ICpdsSummaryRetriever>();
        }
    }
}
