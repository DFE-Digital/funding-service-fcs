namespace ContractRequestDomain.EngagementWatcher.Tests
{
    using EngagementWatcher;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EndpointConfigTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EndpointConfig_ExposesEndpointSubscriptionsAndRoutes()
        {
            var config = new EndpointConfig();

            Assert.AreEqual("ContractRequestDomain.EngagementWatcher", config.EndpointName);
            Assert.AreEqual("ContractRequestDomain.EngagementWatcher.dll", config.NameOfAssembly);
        }
    }
}
