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

            container.BeginScope();

            // act, assert
            container.Resolve<Xrm.ContractTerminationCancelledHandler>();
        }
    }
}
