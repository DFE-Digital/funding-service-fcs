namespace ContractRequestDomain.Tests
{
    using System.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Common.Utils;

    [TestClass]
    public class ConfigurationHelperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetSetting_Int_ReturnsConfiguredValueAndFallsBackForInvalidOrMissingValues()
        {
            const string validKey = "ConfigurationHelperTests.ValidInteger";
            const string invalidKey = "ConfigurationHelperTests.InvalidInteger";
            const string missingKey = "ConfigurationHelperTests.MissingInteger";
            ConfigurationManager.AppSettings[validKey] = "42";
            ConfigurationManager.AppSettings[invalidKey] = "not-an-integer";

            Assert.AreEqual(42, ConfigurationHelper.GetSetting(validKey, 7));
            Assert.AreEqual(7, ConfigurationHelper.GetSetting(invalidKey, 7));
            Assert.AreEqual(7, ConfigurationHelper.GetSetting(missingKey, 7));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetSetting_String_ReturnsConfiguredValueAndFallsBackWhenMissing()
        {
            const string configuredKey = "ConfigurationHelperTests.ConfiguredString";
            const string missingKey = "ConfigurationHelperTests.MissingString";
            ConfigurationManager.AppSettings[configuredKey] = "configured";

            Assert.AreEqual("configured", ConfigurationHelper.GetSetting(configuredKey, "fallback"));
            Assert.AreEqual("fallback", ConfigurationHelper.GetSetting(missingKey, "fallback"));
            Assert.IsNull(ConfigurationHelper.GetSetting(missingKey));
        }
    }
}
