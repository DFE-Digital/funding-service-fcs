namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Common;
    using Common.Commands;
    using global::ContractManagementService.Tests;
    using global::ContractManagementService.Tests.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test.Utils;

    [TestClass]
    public class ContractTerminationControllerTests
    {
        private const string PrefixUrl = "/contractmanagement/contractissueandreturn";
        private const string ApproveTerminationInitiationActionName = "/approveterminationinitiation";
        private const string CancelContractTerminationActionName = "/cancelcontracttermination";
        private const string TerminateContractActionName = "/terminatecontract";
        private const string UpdateContractTerminationDetailsActionName = "/updatecontractterminationdetails";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_UpdateContractTerminationDetails_WhenProvidedWithValidRequestParametersButRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateContractTerminationDetailsActionName}";

            using (HttpClient client = new HttpClient())
            {
                UpdateContractTerminationDetailsCommand command = new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ESF-145",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_UpdateContractTerminationDetails_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateContractTerminationDetailsActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                UpdateContractTerminationDetailsCommand command = new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "ESF-145",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_UpdateContractTerminationDetails_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{UpdateContractTerminationDetailsActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                UpdateContractTerminationDetailsCommand command = new UpdateContractTerminationDetailsCommand
                {
                    ContractNumber = "",
                    VersionNumber = 1,
                    SubVersionNumber = 0
                };
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_ApproveTerminationInitiation_WhenProvidedWithValidRequestParametersButRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveTerminationInitiationActionName}";

            using (HttpClient client = new HttpClient())
            {
                ApproveContractTerminationInitiationCommand command = new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ESF-145",
                    VersionNumber = 1,
                    SubVersionNumber = 0,
                    ShouldInitiateAmendmentOnApproval = true
                };
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_ApproveTerminationInitiation_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveTerminationInitiationActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ApproveContractTerminationInitiationCommand command = new ApproveContractTerminationInitiationCommand
                {
                    ContractNumber = "ESF-145",
                    VersionNumber = 1, 
                    SubVersionNumber = 0,
                    ShouldInitiateAmendmentOnApproval = true
                };
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, command).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_ApproveTerminationInitiation_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveTerminationInitiationActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("", 1, 1);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_CancelContractTermination_WhenProvidedWithValidRequestParametersButRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelContractTerminationActionName}";

            using (HttpClient client = new HttpClient())
            {
                ContractIdentifier contractIdentifier = new ContractIdentifier(contractNumber: "ESF-145", versionNumber: 1, subVersionNumber: 1);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, contractIdentifier).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_CancelContractTermination_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelContractTerminationActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_CancelContractTermination_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{CancelContractTerminationActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("", 1, 1);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_TerminateContract_WhenProvidedWithValidRequestParametersButRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{TerminateContractActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_TerminateContract_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{TerminateContractActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationController_TerminateContract_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{TerminateContractActionName}";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("", 1, 1);
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
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