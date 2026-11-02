namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm.Repositories
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;

    [TestClass]
    public class CrmProviderRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmProviderRepository_GetProviderEntityReference_ShouldReturnProviderEntityReference()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var (ukprn, expectedProviderEntityReference) = GetAnyProviderInfo(restApiUrl, accessToken);

            var repository = new CrmProviderRepository(appConfiguration);

            // act
            var returnedProviderEntityReference = repository.GetProviderEntityReference(ukprn).Result;

            // assert 
            Assert.AreEqual(expectedProviderEntityReference, returnedProviderEntityReference, "Incorrect ProviderEntityReference returned");
        }

        public Tuple<string, string> GetAnyProviderInfo(string restApiUrl, string accessToken)
        {
            var url = $"{restApiUrl}accounts?$select=name,sfa_ukprn&$top=1&$filter=sfa_ukprn ne null";
            var content = HttpGet(url, accessToken);

            return Tuple.Create((string)content["value"][0]["sfa_ukprn"], ((string)content["value"][0]["accountid"]).ToUpper());
        }

        private static JObject HttpGet(string url, string accessToken)
        {
            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(url).Result;

                return (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);
            }
        }
    }
}