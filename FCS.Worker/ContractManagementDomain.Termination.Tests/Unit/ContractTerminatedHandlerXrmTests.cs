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

            container.BeginScope();

            // act, assert
            container.Resolve<Xrm.ContractTerminatedHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminationFailedHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new Xrm.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<Xrm.ContractTerminationFailedHandler>().ImplementedBy<Xrm.ContractTerminationFailedHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<Xrm.ContractTerminationFailedHandler>();
        }
    }
}