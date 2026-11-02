namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utils;

    [TestClass]
    public class PerformanceManagementControllerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PerformanceManagementControllerTests_ShouldBeAbleToPostClaimInformationToEndpoint()
        {
            using (var client = GetAuthorizedHttpClient())
            {
                StringContent httpContent = new StringContent($"<ClaimInformation><FCRId>{Guid.NewGuid()}</FCRId><FCRName>X</FCRName></ClaimInformation>", Encoding.UTF8, "application/xml");
                string url = GetRootUrl() + "/api/performance-management/funding-claim-reconciliations/ConfirmPublish";
                HttpResponseMessage result = client.PostAsync(url, httpContent).Result;
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode);
            }
        }

        private string GetRootUrl()
        {
            return new AppConfiguration()["ContractManagementServiceUrl"];
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }
    }
}
