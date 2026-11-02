namespace SFA.FCT.ContractManagementService.Tests.Integration
{
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Common.Commands;
    using global::ContractManagementService.Tests.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Test.Utils;

    [TestClass]
    public class ContractManagementCfsReleaseControllerTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void ContractManagementCfsReleaseController_ShouldReturnAccepted()
        {
            HttpStatusCode returnedStatusCode;
            string url = $"{GetBaseUrl()}/contractmanagement/contractissueandreturn/cfs-release/allocations";

            using (HttpClient client = GetAuthorizedHttpClient())
            {
                
                // Act
                returnedStatusCode = client.PostAsJsonAsync(url, new InitiateCfsAllocationReleaseCommand
                {
                    FundingPeriod = "FP",
                    FundingType = "FT"
                }).Result.StatusCode;
            }

            // Assert
            Assert.AreEqual(HttpStatusCode.Accepted, returnedStatusCode);
        }

        private static string GetBaseUrl()
        {
            return ConfigurationManager.AppSettings["ContractManagementServiceUrl"];
        }

        private static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient();

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthentication.GetAuthenticationResult());
            return client;
        }
    }
}
