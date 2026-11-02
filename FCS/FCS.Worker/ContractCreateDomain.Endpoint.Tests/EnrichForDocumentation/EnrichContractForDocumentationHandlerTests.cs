namespace ContractCreateDomain.Endpoint.Tests.EnrichForDocumentation
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.EnrichForDocumentation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class EnrichContractForDocumentationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnrichContractForDocumentationHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<EnrichContractForDocumentationHandler>());

            container.BeginScope();

            // act
            container.Resolve<EnrichContractForDocumentationHandler>();
        }
    }
}
