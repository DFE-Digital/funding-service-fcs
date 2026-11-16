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

            container.BeginScope();

            // act
            container.Resolve<CancelContractModificationHandler>();
        }
    }
}
