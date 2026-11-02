namespace ContractManagementService.Tests.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.ContractManagementService.Test.Utils;

    [TestClass]
    public class ContractModificationControllerTests
    {
        private const string PrefixUrl = "/contractmanagement/contractissueandreturn";
        private const string ApproveModificationActionName = "/approvemodification";
        private const string UpdateModificationActionName = "/updatemodification";
        private const string CancelModificationActionName = "/cancelmodification";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_ApproveModification_WhenRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveModificationActionName}";

            var command = new ApproveContractTerminationInitiationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0,
                ShouldInitiateAmendmentOnApproval = true
            };

            using (var client = new HttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_ApproveModification_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveModificationActionName}";

            var command = new ApproveContractModificationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_ApproveModification_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveModificationActionName}";

            var command = new ApproveContractModificationCommand
            {
                ContractNumber = "",
                VersionNumber = 0,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_UpdateModification_WhenRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateModificationActionName}";

            var command = new UpdateContractModificationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0
            };

            using (var client = new HttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_UpdateModification_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateModificationActionName}";

            var command = new UpdateContractModificationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_UpdateModification_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateModificationActionName}";

            var command = new UpdateContractModificationCommand
            {
                ContractNumber = "",
                VersionNumber = 0,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_CancelModification_WhenRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelModificationActionName}";

            var command = new CancelContractModificationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0
            };

            using (var client = new HttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_CancelModification_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelModificationActionName}";

            var command = new CancelContractModificationCommand
            {
                ContractNumber = "ESF-145",
                VersionNumber = 1,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractModificationController_CancelModification_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // arrange
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelModificationActionName}";

            var command = new CancelContractModificationCommand
            {
                ContractNumber = "",
                VersionNumber = 0,
                SubVersionNumber = 0
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // act
                HttpStatusCode returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;

                // assert
                Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
            }
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }

        private static string GetBaseUrl()
        {
            return new AppConfiguration()["ContractManagementServiceUrl"];
        }
    }
}