namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Common;
    using global::ContractManagementService.Tests;
    using global::ContractManagementService.Tests.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Test.Utils;

    [TestClass]
    public class ContractManagementControllerTests
    {
        private readonly string _baseUrl = new AppConfiguration()["ContractManagementServiceUrl"];

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_ShouldRespondToAuthorisedRequestWithHttpSuccess()
        {
            const string contractNumber = "C123456789";
            const string masterContractNumber = "M12345678";
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/confirmpublicationtoprovider";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber
            };
            HttpResponseMessage response;

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                response = client.PostAsJsonAsync(url, content).Result;
            }

            Assert.AreEqual(HttpStatusCode.Accepted, response.StatusCode, $"Contract Management Controller did not respond with HTTP 202, status code was {response.StatusCode}");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_ShouldRejectUnauthorisedRequest()
        {
            const string contractNumber = "C123456789";
            const string masterContractNumber = "M12345678";
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/confirmpublicationtoprovider";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber
            };
            string response;

            using (HttpClient client = new HttpClient())
            {
                HttpResponseMessage result = client.PostAsJsonAsync(url, content).Result;

                // assert
                Assert.AreEqual(HttpStatusCode.Unauthorized, result.StatusCode);
                response = result.Content.ReadAsStringAsync().Result;
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_DeleteDraftContract_ShouldRespondBadRequestIfContractInformationNull()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/deletedraftcontract";
            ContractInformation content = null;

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Delete, url)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(content), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;
                
                Assert.AreEqual(HttpStatusCode.BadRequest, result.StatusCode, "Did not get Bad Request Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_ShouldGetAcceptedCodeWhenCallingConfirmreceiptofdigitalsignatureWithJson()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/confirmreceiptofdigitalsignature";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = "XX",
                ContractVersionNumber = 1,
                MasterContractNumber = "123"
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, url)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(content), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;

                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_ShouldGetAcceptedCodeWhenCallingConfirmreceiptofdigitalsignatureWithXml()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/confirmreceiptofdigitalsignature";
            const string crmXml = "<ContractInformation xmlns:xsi =\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ContractNumber>MAIN-5678</ContractNumber><MasterContractNumber>SFA-1234</MasterContractNumber><ContractVersionNumber>5</ContractVersionNumber></ContractInformation>";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, url)
                {
                    Content = new StringContent(crmXml, Encoding.UTF8, "application/xml")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;

                Assert.AreEqual(HttpStatusCode.Accepted, result.StatusCode, "Did not get Accepted Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_DeleteDraftContract_ShouldRespondBadRequestIfContractNumberEmpty()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/deletedraftcontract";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = string.Empty,
                ContractVersionNumber = 1
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Delete, url)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(content), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;

                Assert.AreEqual(HttpStatusCode.BadRequest, result.StatusCode, "Did not get Bad Request Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_DeleteDraftContract_ShouldRespondBadRequestIfVersionNull()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/deletedraftcontract";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = "C123456789",
                ContractVersionNumber = null
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Delete, url)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(content), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;

                Assert.AreEqual(HttpStatusCode.BadRequest, result.StatusCode, "Did not get Bad Request Response");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementController_DeleteDraftContract_ShouldRespondAcceptedIfAllDataIsPresent()
        {
            string url = $"{_baseUrl}/contractmanagement/contractissueandreturn/deletedraftcontract";
            ContractInformation content = new ContractInformation
            {
                ContractNumber = "C123456789",
                ContractVersionNumber = 1
            };

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Delete, url)
                {
                    Content = new StringContent(JsonConvert.SerializeObject(content), Encoding.UTF8, "application/json")
                };

                HttpResponseMessage result = client.SendAsync(request).Result;

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
