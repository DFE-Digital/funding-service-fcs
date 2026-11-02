namespace ContractCreateDomain.Endpoint.Tests.CreateProvidersIfNecessary
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.CreateProvidersIfNecessary;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CreateProvidersIfNecessaryHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<CreateProvidersIfNecessaryHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreateProvidersIfNecessaryHandler>();
        }
    }
}
