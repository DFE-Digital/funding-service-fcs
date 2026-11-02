namespace SFA.FCT.ContractManagementService.Test.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Utils;

    [TestClass]
    public class ContractManagementAzureAdAuthorisationTest
    {
        private const string MostRecentPageUrl = "/api/contracts/notifications/approvals";
        
        private static string BaseAddress => new AppConfiguration()["ContractManagementServiceUrl"];

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldReturnAzureBearerToken()
        {
            var result =  AzureAuthentication.GetAuthenticationResult();

            Assert.IsNotNull(result);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ShouldFailAccessToServiceNoBearerToken()
        {
            string url = string.Format(MostRecentPageUrl);
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url, string.Empty);

            Assert.IsFalse(IsSuccessStatusCode(response));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ShouldFailAccessToServiceInvalidBearerToken()
        {
            const string accessToken = "AAABBB";
            string url = string.Format(MostRecentPageUrl);
            var response = await CallEndpointAndReturnResultAsync("application/atom+xml", url, accessToken);

            Assert.IsFalse(IsSuccessStatusCode(response));
        }

        private async Task<HttpStatusCode> CallEndpointAndReturnResultAsync(string mediaType, string url, string token)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            HttpResponseMessage response = await client.GetAsync(BaseAddress + url);
                        
            return response.StatusCode;
           
        }

        public bool IsSuccessStatusCode(HttpStatusCode statusCode)
        {
             return ((int)statusCode >= 200) && ((int)statusCode <= 299);
        }    
    }
}
