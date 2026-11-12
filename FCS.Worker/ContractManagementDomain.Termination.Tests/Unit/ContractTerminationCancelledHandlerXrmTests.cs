namespace ContractManagementDomain.Termination.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractTerminationCancelledHandlerXrmTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminationCancelledHandlerXrm_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new Xrm.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Xrm.ContractTerminationCancelledHandler>().ImplementedBy<Xrm.ContractTerminationCancelledHandler>());
            _ = container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            _ = container.BeginScope();

            // act, assert
            _ = container.Resolve<Xrm.ContractTerminationCancelledHandler>();
        }
    }
}
