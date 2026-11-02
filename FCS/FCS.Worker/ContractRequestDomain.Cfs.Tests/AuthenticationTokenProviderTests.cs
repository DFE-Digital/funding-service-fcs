namespace ContractRequestDomain.Cfs.Tests
{
    using ContractRequestDomain.Cfs.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;

    [TestClass]
    public class AuthenticationTokenProviderTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AuthenticationTokenProvider_ShouldGetToken()
        {
            // arrange
            string claimsProviderUrl = ConfigurationManager.AppSettings["Cfs:ClaimsProvider"];
            string tenantId = ConfigurationManager.AppSettings["Cfs:TenantId"];
            string clientId = ConfigurationManager.AppSettings["Cfs:ClientId"];
            string clientSecret = ConfigurationManager.AppSettings["Cfs:ClientSecret"];
            string resource = ConfigurationManager.AppSettings["Cfs:Resource"];

            // act
            string token = AuthenticationTokenProvider.GetToken(
                claimsProviderUrl: claimsProviderUrl,
                tenantId: tenantId,
                clientId: clientId,
                clientSecret: clientSecret,
                resource: resource);

            // assert
            Assert.IsNotNull(token);
        }
    }
}
