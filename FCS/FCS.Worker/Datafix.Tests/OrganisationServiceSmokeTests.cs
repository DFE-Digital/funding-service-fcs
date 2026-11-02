namespace Datafix.Tests
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Authentication;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OrganisationServiceSmokeTests
    {
        [TestMethod, TestCategory("SmokeTest")]
        public void SmokeTest_ShouldCallOrgServiceSuccessfully()
        {
            // arrange
            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));

                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                    "Bearer",
                    AzureAuthenticator.GetAuthenticationResult("OrgService"));

                Uri orgServiceUri = new Uri(ConfigurationManager.AppSettings["OrgServiceUrl"]);
                string testUri = $"{orgServiceUri.Scheme}://{orgServiceUri.Host}/api/v1/test";

                // act
                HttpResponseMessage response = client.GetAsync(testUri).Result;

                // assert
                response.EnsureSuccessStatusCode();
            }
        }
    }
}
