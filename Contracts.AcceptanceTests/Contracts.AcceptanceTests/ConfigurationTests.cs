using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using SFA.FCT.Contracts.AcceptanceTests;

namespace Contracts.AcceptanceTests
{
    [TestClass]
    public class ConfigurationTests
    {
        [TestMethod]
        public void Verify_DAT_Configuration_Is_Loaded()
        {
            Environment.SetEnvironmentVariable("Environment", "DAT");

            var configuration = TestConfiguration.Configuration;

            bool useKeyVault = bool.Parse(configuration["UseKeyVault"]);
            string storageTableSuffix = configuration["StorageTableSuffix"];

            Assert.AreEqual("DAT", storageTableSuffix);
            Assert.IsTrue(useKeyVault);
            Assert.AreEqual("false", configuration["AzureStorage:UseForBulkUpload"]);
            Assert.AreEqual("Input", configuration["Office365BulkUpload:InputFolder"]);
            Assert.AreEqual("Reports", configuration["Office365BulkUpload:OutputFolder"]);
        }
    }
}