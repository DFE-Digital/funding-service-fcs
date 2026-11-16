namespace ContractManagementDomain.Termination.Tests.Unit
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class ApproveContractModificationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ApproveContractModificationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ApproveContractModificationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ApproveContractModificationHandler>();
        }
    }
}
