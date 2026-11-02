namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.DTOs;
    using ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;

    [TestClass]
    public class RoatpApiHttpClientTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void RoatpApiHttpClient_GetAllProviders_ShouldGetDataFromRoatpApi()
        {
            // arrange
            string[] expectedApplicationTypes = { "MainProvider", "SupportingProvider", "EmployerProvider", "EPAO" };
            //Added EPAO provider type as we are receving EPAO applicaion type from ROATP apprenticeships services

            ConfigurationManager.AppSettings["RoatpService:Url"] = "https://download-api.apprenticeships.education.gov.uk";
            RoatpApiHttpClient roatpApiHttpClient = new RoatpApiHttpClient();

            // act
            IReadOnlyCollection<RoatpProvider> allProviders = FunctionRetrier.RetryWhenExceptionThrown(
                () => roatpApiHttpClient.GetAllProviders().Result,
                numRetries: 5);

            // assert
            Assert.IsNotNull(allProviders, "Null result returned from RoatpApiHttpClient");
            Assert.IsTrue(allProviders.Any(), "No providers returned from RoatpApiHttpClient");

            RoatpProvider expectedRoatpProvider = allProviders.SingleOrDefault(p => p.Ukprn == "10000020");
            Assert.IsNotNull(expectedRoatpProvider, "Expected provider not returned from RoatpApiHttpClient");
            Assert.AreEqual("MainProvider", expectedRoatpProvider.ApplicationType, "Expected provider returned with unexpected Provider Type");

            List<string> unexpectedApplicationTypes =
                allProviders
                    .Where(p => !expectedApplicationTypes.Contains(p.ApplicationType))
                    .Select(p => p.ApplicationType)
                    .Distinct()
                    .ToList();
            Assert.AreEqual(0, unexpectedApplicationTypes.Count,
                $"Unexpected Provider Types returned: [{string.Join(", ", unexpectedApplicationTypes)}] when we expected the following only: {string.Join(", ", expectedApplicationTypes)}");
        }
    }
}