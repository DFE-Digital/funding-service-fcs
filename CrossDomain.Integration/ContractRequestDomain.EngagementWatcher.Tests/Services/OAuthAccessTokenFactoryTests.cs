namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using SFA.FCT.ContractRequestDomain.EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OAuthAccessTokenFactoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void OAuthAccessTokenFactory_ShouldReturnAccessToken()
        {
            // Arrange
            const string clientId = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
            const string appKey = "";
            const string resourceId = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
            var service = new OAuthAccessTokenFactory();

            // Act
            var accessToken = service.GetAccessToken(clientId, appKey, resourceId);

            // Assert
            Assert.IsNotNull(accessToken, "Access token was not returned");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OAuthAccessTokenFactory_ShouldReturnSameAccessTokenWhenCalledTwice()
        {
            // Arrange
            const string clientId = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
            const string appKey = "";
            const string resourceId = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
            var service = new OAuthAccessTokenFactory();

            var accessToken = service.GetAccessToken(clientId, appKey, resourceId);

            // Act
            var assertAccessToken = service.GetAccessToken(clientId, appKey, resourceId);

            // Assert
            Assert.AreEqual(accessToken, assertAccessToken, "Access tokens are not the same");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OAuthAccessTokenFactory_WhenCalledTwiceShouldReturnDifferentAccessTokenWhenClearCacheMethodIsCalledInBetween()
        {
            // Arrange
            const string clientId = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
            const string appKey = "";
            const string resourceId = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
            var service = new OAuthAccessTokenFactory();

            var accessToken = service.GetAccessToken(clientId, appKey, resourceId);
            service.ClearCache();

            // Act
            var assertAccessToken = service.GetAccessToken(clientId, appKey, resourceId);

            // Assert
            Assert.AreNotEqual(accessToken, assertAccessToken, "Access tokens are the same");
        }
    }
}