namespace ContractManagementService.Tests.Integration
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Test.Utils;

    [TestClass]
    public class AllocationNotificationFeedControllerTests
    {
        public const string RoutePrefix = "/api/allocation-delivery/monitoring/notifications/all";
        private const string MediaType = "application/vnd.sfa.allocation-delivery.allocation-delivery-performance.v1+atom+xml";

        private static string BaseAddress => new AppConfiguration()["ContractManagementServiceUrl"];

        [TestMethod, TestCategory("IntegrationTest")]
        public void EnsureControllerGetLatestAllocationDeliveryMonitoringPageMethodExecutesOk()
        {
            // arrange & act
            var response = CallEndpointAndReturnHttpResponseMessageAsync(MediaType, RoutePrefix).Result;

            // assert
            Assert.IsTrue(response.IsSuccessStatusCode);
        }

        private async Task<HttpResponseMessage> CallEndpointAndReturnHttpResponseMessageAsync(string mediaType, string url)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders
                .Accept
                .Add(new MediaTypeWithQualityHeaderValue(mediaType));

            AddAuthorizationHeader(client);

            return await client.GetAsync(BaseAddress + url);
        }

        private void AddAuthorizationHeader(HttpClient client)
        {
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
        }
    }
}