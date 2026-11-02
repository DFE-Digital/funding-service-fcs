namespace ContractManagementDomain.Termination.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class UpdateContractModificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateContractModificationHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateContractModificationHandler>().ImplementedBy<UpdateContractModificationHandler>());

            container.BeginScope();

            Assert.IsNotNull(container.Resolve<UpdateContractModificationHandler>());
        }
    }
}
