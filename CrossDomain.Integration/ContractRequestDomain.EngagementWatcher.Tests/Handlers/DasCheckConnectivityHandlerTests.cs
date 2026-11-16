namespace ContractRequestDomain.EngagementWatcher.Tests.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.ContractRequestDomain.EngagementWatcher.Handlers;
   
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class DasCheckConnectivityHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DasCheckConnectivityHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                //.Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<DasCheckConnectivityHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<DasCheckConnectivityHandler>();
        }
    }
}
