namespace AllocationDeliveryDomain.Endpoint.Tests.Infrastructure
{
    using System.Configuration;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ConfigurationRetrieverTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ConfigurationRetriever_ShouldGetAppSetting()
        {
            // arrange
            const string someSettingName = "SomeSetting";
            const string someSettingValue = "X";

            ConfigurationManager.AppSettings[someSettingName] = someSettingValue;

            // act
            var suffix = ConfigurationRetriever.GetAppSetting(someSettingName);

            // assert
            Assert.AreEqual(someSettingValue, suffix);
        }
    }
}
