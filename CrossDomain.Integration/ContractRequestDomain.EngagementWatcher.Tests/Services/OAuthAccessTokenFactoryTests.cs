namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using System;
    using EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OAuthAccessTokenFactoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetAccessToken_CachesTokenUntilCacheIsCleared()
        {
            var requestCount = 0;
            var service = new OAuthAccessTokenFactory((clientId, appKey, resourceId) =>
            {
                requestCount++;
                return "token-" + requestCount;
            });

            service.ClearCache();
            try
            {
                var firstToken = service.GetAccessToken("client", "secret", "resource");
                var cachedToken = service.GetAccessToken("client", "secret", "resource");

                Assert.AreEqual("token-1", firstToken);
                Assert.AreEqual(firstToken, cachedToken);
                Assert.AreEqual(1, requestCount);

                service.ClearCache();
                var refreshedToken = service.GetAccessToken("client", "secret", "resource");

                Assert.AreEqual("token-2", refreshedToken);
                Assert.AreEqual(2, requestCount);
            }
            finally
            {
                service.ClearCache();
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Constructor_WhenTokenRequesterIsNull_ThrowsArgumentNullException()
        {
            try
            {
                new OAuthAccessTokenFactory(null);
                Assert.Fail("Expected ArgumentNullException.");
            }
            catch (ArgumentNullException)
            {
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void OAuthAccessTokenFactory_ShouldReturnAccessToken()
        {
            // Arrange
            const string clientId = "";
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
            const string clientId = "";
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
            const string clientId = "";
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