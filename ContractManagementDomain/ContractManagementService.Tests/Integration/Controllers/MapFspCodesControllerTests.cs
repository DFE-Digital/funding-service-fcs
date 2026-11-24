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
        private const string EndpointPath = "/api/configuration/fspcodes";
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
            FundingAllocationConfigSeeder.EnsureAsfAllocationPeriod2526Exists();

            var url = $"{GetBaseUrl()}{EndpointPath}?allocationFundingStreamCode=ASF&allocationPeriodCode=AY-2526";

            using var client = GetAuthorizedHttpClient();
            using var response = await client.GetAsync(url);
            var responseContent = await response.Content.ReadAsStringAsync();
            Assert.AreEqual(
                HttpStatusCode.OK,
                response.StatusCode,
                $"GET {url} returned {(int)response.StatusCode}. Body: {(responseContent.Length > 500 ? responseContent.Substring(0, 500) : responseContent)}");

            var result = JsonConvert.DeserializeObject<FundingStreamPeriodCodesResponse>(responseContent);

            Assert.IsNotNull(result, $"Could not deserialize response: {responseContent}");
            var expected = new[]
            {
                "ASF2023-AS2526",
                "ASF2023-FCFJ2526",
                "ASFC-ASCL2526",
                "ASFC-FCFJ2526"
            };
            var actual = result.FundingStreamPeriodCodes.ToArray();

            CollectionAssert.IsSubsetOf(
                expected,
                actual,
                $"Missing: [{string.Join(", ", expected.Except(actual))}]. Actual ({actual.Length}): [{string.Join(", ", actual)}]. Body: {responseContent}");
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
