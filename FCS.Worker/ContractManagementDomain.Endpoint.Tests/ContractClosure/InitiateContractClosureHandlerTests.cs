namespace ContractManagementDomain.Endpoint.Tests.ContractClosure
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractClosure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class InitiateContractClosureHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractClosureHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container =
                new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault())
                .Register(Component.For<InitiateContractClosureHandler>());

            container.BeginScope();

            // act
            container.Resolve<InitiateContractClosureHandler>();
        }
    }
}
