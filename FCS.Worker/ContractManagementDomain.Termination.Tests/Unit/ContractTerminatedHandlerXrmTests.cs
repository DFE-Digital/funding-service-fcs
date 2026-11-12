namespace ContractManagementDomain.Termination.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ContractTerminatedHandlerXrmTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminatedHandlerXrm_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new Xrm.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Xrm.ContractTerminatedHandler>().ImplementedBy<Xrm.ContractTerminatedHandler>());
            _ = container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            _ = container.BeginScope();

            // act, assert
            _ = container.Resolve<Xrm.ContractTerminatedHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminationFailedHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new Xrm.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Xrm.ContractTerminationFailedHandler>().ImplementedBy<Xrm.ContractTerminationFailedHandler>());
            _ = container.Register(Component.For<Microsoft.Xrm.Sdk.IOrganizationService>().Instance(Moq.Mock.Of<Microsoft.Xrm.Sdk.IOrganizationService>()).IsDefault());

            _ = container.BeginScope();

            // act, assert
            _ = container.Resolve<Xrm.ContractTerminationFailedHandler>();
        }
    }
}