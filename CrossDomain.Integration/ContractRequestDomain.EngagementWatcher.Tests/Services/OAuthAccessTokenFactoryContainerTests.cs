namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using SFA.FCT.ContractRequestDomain.EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OAuthAccessTokenFactoryContainerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OAuthAccessTokenFactory_ResolvesFromContainerWithoutExtraRegistrations()
        {
            using (var container = new WindsorContainer())
            {
                container.Register(Component.For<IOAuthAccessTokenFactory>().ImplementedBy<OAuthAccessTokenFactory>().LifestyleSingleton());

                var resolved = container.Resolve<IOAuthAccessTokenFactory>();

                Assert.IsInstanceOfType(resolved, typeof(OAuthAccessTokenFactory));
            }
        }
    }
}
