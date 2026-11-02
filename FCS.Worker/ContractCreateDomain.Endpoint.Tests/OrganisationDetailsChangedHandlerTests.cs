namespace ContractCreateDomain.Endpoint.Tests
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractCreateDomain.Endpoint.Organisation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class OrganisationDetailsChangedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationDetailsChangedHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<OrganisationDetailsChangedHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<OrganisationDetailsChangedHandler>();
        }
    }
}
