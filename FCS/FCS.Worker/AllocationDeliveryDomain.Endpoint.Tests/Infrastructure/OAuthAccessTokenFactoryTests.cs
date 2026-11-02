namespace AllocationDeliveryDomain.Endpoint.Tests.Infrastructure
{
    using System.Configuration;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OAuthAccessTokenFactoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void OAuthAccessTokenFactory_ShouldGetTokenForDCT()
        {
            // arrange
            OAuthAccessTokenFactory oAuthAccessTokenFactory = new OAuthAccessTokenFactory();
            var clientId = ConfigurationManager.AppSettings["DCT:Oauth:ClientId"];
            var scope = ConfigurationManager.AppSettings["DCT:Oauth:Scope"];
            var clientSecret = ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"];
            var tenant = ConfigurationManager.AppSettings["DCT:Oauth:Tenant"];

            // act
            var token = oAuthAccessTokenFactory.GetAccessToken(clientId: clientId, clientSecret: clientSecret, scope: scope,
                tenant: tenant);
            // assert
            Assert.IsNotNull(token);
        }
    }
}
