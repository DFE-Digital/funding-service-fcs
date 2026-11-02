namespace ContractCreateDomain.Endpoint.Tests.ContractCreated
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractCreated;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractCreatedInCrmHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractCreatedInCrmHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractCreatedInCrmHandler>());

            container.BeginScope();

            // act
            container.Resolve<ContractCreatedInCrmHandler>();
        }
    }
}
