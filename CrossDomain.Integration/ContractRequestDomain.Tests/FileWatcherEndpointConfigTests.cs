namespace ContractRequestDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Integration.FileWatcher;

    [TestClass]
    public class FileWatcherEndpointConfigTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EndpointConfig_ExposesEndpointMetadataAndEmptyRoutes()
        {
            var config = new EndpointConfig();

            Assert.AreEqual("ContractRequestDomain.Integration.FileWatcher.dll", config.NameOfAssembly);
            Assert.AreEqual("ContractRequestDomain.FileWatcher", config.EndpointName);
        }
    }
}
