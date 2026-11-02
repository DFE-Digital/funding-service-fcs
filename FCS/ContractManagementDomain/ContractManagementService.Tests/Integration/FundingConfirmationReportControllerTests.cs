namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Test.Utils;

    [TestClass]
    public class FundingConfirmationReportControllerTests
    {
        private const string Url = "/contractmanagement/funding-confirmation-report";

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingConfirmationReportController_CreateFundingConfirmationReport_ShouldReturnStatusCodeAccepted()
        {
            // Arrange
            var fullUrl = $"{GetBaseUrl()}{Url}";

            // Act
            var returnedStatusCode = GetAuthorizedHttpClient().PostAsync(fullUrl, null).Result.StatusCode;

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }

        private static string GetBaseUrl()
        {
            return ConfigurationManager.AppSettings["ContractManagementServiceUrl"];
        }

    }
}