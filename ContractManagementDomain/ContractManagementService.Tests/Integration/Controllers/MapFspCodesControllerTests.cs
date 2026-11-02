using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using ContractManagementService.DTOs;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using SFA.FCT.ContractManagementService.Test.Integration;
using SFA.FCT.ContractManagementService.Test.Utils;

namespace ContractManagementService.Tests.Integration.Controllers
{
    [TestClass]
    public class MapFspCodesControllerTests : IntegrationTestBase
    {
        private const string EndpointPath = "api/configuration/fspcodes";
        private static string GetBaseUrl() => new AppConfiguration()["ContractManagementServiceUrl"];

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task MapFspCodes_WhenRequestIsUnauthorized_ReturnsUnauthorized()
        {
            var url = $"{GetBaseUrl()}{EndpointPath}?allocationFundingStreamCode=ASF&allocationPeriodCode=AY-2526";

            using var client = new HttpClient();
            var response = await client.GetAsync(url);

            Assert.AreEqual(HttpStatusCode.Unauthorized, response.StatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public async Task MapFspCodes_WhenProvidedWithValidRequest_ReturnsExpectedCodes()
        {
            var url = $"{GetBaseUrl()}{EndpointPath}?allocationFundingStreamCode=ASF&allocationPeriodCode=AY-2526";

            using var client = GetAuthorizedHttpClient();
            using var response = await client.GetAsync(url);
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

            var responseContent = await response.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<FundingStreamPeriodCodesResponse>(responseContent);

            Assert.IsNotNull(result);
            CollectionAssert.IsSubsetOf(
                new[]
                {
                    "ASF2023-AS2526",
                    "ASF2023-FCFJ2526",
                    "ASFC-ASCL2526",
                    "ASFC-FCFJ2526"
                },
                result.FundingStreamPeriodCodes.ToArray());
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
