namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Handlers
{
    using Castle.Windsor;
    using ContractCreateDomain.IncrementContractVersionEndpoint.Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;
    using IoC;
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.Lifestyle;

    [TestClass]
    public class DocumentGenerationCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<DocumentGenerationCompleteHandler>().ImplementedBy<DocumentGenerationCompleteHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<DocumentGenerationCompleteHandler>();
        }
    }
}