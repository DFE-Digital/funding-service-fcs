namespace ContractManagementService.Tests.Integration
{
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractManagementService.Test.Utils;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class FundingClaimReconciliationCommandControllerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingClaimReconciliationCommandController_ShouldReturnAccepted()
        {
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}/api/performance-management/funding-claim-reconciliations/recalc";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, new InitiateReCalculationForFcrCommand
                {
                    FcrId = "Test",
                    HasFinalReconciliationValueChanged = true
                }).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        private static string GetBaseUrl()
        {
            return new ContractManagementService.Tests.AppConfiguration()["ContractManagementServiceUrl"];
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }
    }
}
