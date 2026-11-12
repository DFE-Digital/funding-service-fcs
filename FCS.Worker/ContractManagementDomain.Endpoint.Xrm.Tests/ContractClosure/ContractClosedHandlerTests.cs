namespace ContractManagementDomain.Endpoint.Xrm.Tests.ContractClosure
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;
    using Xrm.ContractClosure;

    [TestClass]
    public class ContractClosedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractClosedHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            IWindsorContainer container =
                new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault())
                .Register(Component.For<ContractClosedHandler>());
            container.BeginScope();

            container.Resolve<ContractClosedHandler>();
        }
    }
}
