namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using CrossDomain.Integration.Messages.Commands;
    using global::ContractManagementService.Tests;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Test.Utils;

    [TestClass]
    public class FundingAllocationControllerTests
    {
        private readonly string _baseUrl = new AppConfiguration()["ContractManagementServiceUrl"];

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_ReleaseGroup_ShouldRespondWithAccepted()
        {
            string url = $"{_baseUrl}/funding-allocation/release-group";
            FundingAllocationReleaseGroupCommand command = new FundingAllocationReleaseGroupCommand();

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8,
                    "application/json");

                HttpResponseMessage result = client.PostAsync(url, content).Result;

                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_HoldEvent_ShouldRespondWithAccepted()
        {
            // arrange
            string url = $"{_baseUrl}/funding-allocation/holdevent";

            var command = new HoldFundingAllocationCommand
            {
                FundingId = "PSG-AY-2021-10083619-1_0"
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8, "application/json");

                // act
                HttpResponseMessage result = client.PostAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_UnHoldEvent_ShouldRespondWithAccepted()
        {
            // arrange
            string url = $"{_baseUrl}/funding-allocation/un-holdevent";

            var command = new UnHoldFundingAllocationCommand
            {
                FundingId = "PSG-AY-2021-10083619-1_0"
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8, "application/json");

                // act
                HttpResponseMessage result = client.PostAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_WithdrawEvent_ShouldRespondWithAccepted()
        {
            // arrange
            string url = $"{_baseUrl}/funding-allocation/withdrawalevent";

            var command = new WithdrawFundingAllocationCommand
            {
                FundingId = "PSG-AY-2021-10083619-1_0"
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8, "application/json");

                // act
                HttpResponseMessage result = client.PostAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_ReinstateEvent_ShouldRespondWithAccepted()
        {
            // arrange
            string url = $"{_baseUrl}/funding-allocation/reinstate-event";

            var command = new ReinstateFundingAllocationCommand("PSG-AY-2021-10083619-1_0");

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8, "application/json");

                // act
                HttpResponseMessage result = client.PostAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingAllocationController_UnQueueEvent_ShouldRespondWithAccepted()
        {
            // arrange
            var url = $"{_baseUrl}/funding-allocation/un-queue-event";

            var command = new UnQueueFundingAllocationsForContractCommand
            {
                ContractNumber = "CN1",
                VersionNumber = 1,
                SubVersionNumber = 0,
                EventSource = "event source"
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                var content = new StringContent(JsonConvert.SerializeObject(command), Encoding.UTF8, "application/json");

                // act
                HttpResponseMessage result = client.PostAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
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
