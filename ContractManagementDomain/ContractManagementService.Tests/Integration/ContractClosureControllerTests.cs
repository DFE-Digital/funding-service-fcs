namespace ContractManagementService.Tests.Integration
{
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Test.Utils;

    [TestClass]
    public class ContractClosureControllerTests
    {
        private const string PrefixUrl = "/contractmanagement/contractissueandreturn";
        private const string InitiateContractClosureActionName = "/initiatecontractclosure";
        private const string ApproveContractClosureActionName = "/approvecontractclosure";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureController_InitiateContractClosure_WhenProvidedWithValidRequestParametersButRequestIsUnauthorized_ShouldReturnStatusCodeUnauthorized()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{InitiateContractClosureActionName}";

            // Act
            using (HttpClient client = new HttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 1);
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Unauthorized, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureController_InitiateContractClosure_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{InitiateContractClosureActionName}";

            // Act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTestWIP")]
        public void ContractClosureController_InitiateContractClosure_AppService()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            ConfigurationManager.AppSettings["ContractManagementServiceUrl"] =
                "https://fcs-dev-dat-func-x-fctservices-proxy.azurewebsites.net";
           // ConfigurationManager.AppSettings["ResourceId"] = "a525ae4e-b88e-4815-9dce-082162c25f82";

            string url = $"{GetBaseUrl()}{PrefixUrl}{InitiateContractClosureActionName}";

            // Act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureController_InitiateContractClosure_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{InitiateContractClosureActionName}";

            // Act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("", 1, 1);
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.BadRequest, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureController_ApproveContractClosure_WhenProvidedWithValidRequestParameters_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveContractClosureActionName}";

            // Act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("ESF-145", 1, 0);
                returnedStatusCode = client.PostAsJsonAsync(url, closeContractInformation).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractClosureController_ApproveContractClosure_WhenProvidedWithInvalidRequestParameters_ShouldReturnStatusBadRequest()
        {
            // Arrange
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}{PrefixUrl}{ApproveContractClosureActionName}";

            // Act
            using (HttpClient client = GetAuthorizedHttpClient())
            {
                ContractIdentifier closeContractInformation = new ContractIdentifier("", 1, 1);
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
            return new ContractManagementService.Tests.AppConfiguration()["ContractManagementServiceUrl"];
        }
    }
}
