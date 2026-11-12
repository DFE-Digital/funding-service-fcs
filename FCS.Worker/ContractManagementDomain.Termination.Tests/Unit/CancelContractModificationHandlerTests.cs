namespace ContractManagementDomain.Termination.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class CancelContractModificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CancelContractModificationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<CancelContractModificationHandler>());
            _ = container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            _ = container.BeginScope();

            // act
            _ = container.Resolve<CancelContractModificationHandler>();
        }
    }
}
