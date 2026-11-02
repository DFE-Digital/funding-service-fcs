namespace AllocationDeliveryDomain.Endpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;

    [TestClass]
    public class DctApiExploratoryTests
    {
        /// <summary>
        /// -- need to add this to your hosts file
        /// # DCT API
        /// 52.174.34.143     dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk
        /// </summary>
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DctApi_ShouldGetAuthorizationToken()
        {
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            using (HttpClient httpClient = new HttpClient())
            {
                LoginCredentials loginCredentials = new LoginCredentials
                {
                    username = "FCS",
                    password = ""
                };

                HttpResponseMessage response = httpClient.PostAsync(
                    "https://dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk/api/v1.0/token",
                    new StringContent(JsonConvert.SerializeObject(loginCredentials), Encoding.UTF8, "application/json")).Result;

                Assert.IsTrue(response.IsSuccessStatusCode);

                string token = response.Content.ReadAsStringAsync().Result;

                Assert.IsFalse(string.IsNullOrEmpty(token));
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DctApi_ShouldGetClosedCollections()
        {
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            using (HttpClient httpClient = new HttpClient())
            {
                LoginCredentials loginCredentials = new LoginCredentials
                {
                    username = "FCS",
                    password = ""
                };

                HttpResponseMessage tokenResponse = httpClient.PostAsync(
                    "https://dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk/api/v1.0/token",
                    new StringContent(JsonConvert.SerializeObject(loginCredentials), Encoding.UTF8, "application/json")).Result;

                string token = tokenResponse.Content.ReadAsStringAsync().Result;

                httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");

                HttpResponseMessage collectionsResponse = httpClient.GetAsync(
                    "https://dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk/api/v1.0/summarised-actuals/collections?closedcollectionsince=2019-11-05T17:00:00.000").Result;

                Assert.IsTrue(collectionsResponse.IsSuccessStatusCode);

                string collectionsContent = collectionsResponse.Content.ReadAsStringAsync().Result;

                IReadOnlyCollection<Collection> collections = JsonConvert.DeserializeObject<IReadOnlyCollection<Collection>>(collectionsContent);

                Assert.IsNotNull(collections);
                Assert.IsTrue(collections.Any());
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DctApi_ShouldGetSummarisedActualsUsingPageNumber()
        {
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            using (HttpClient httpClient = new HttpClient())
            {
                LoginCredentials loginCredentials = new LoginCredentials
                {
                    username = "FCS",
                    password = ""
                };

                HttpResponseMessage tokenResponse = httpClient.PostAsync(
                    "https://dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk/api/v1.0/token",
                    new StringContent(JsonConvert.SerializeObject(loginCredentials), Encoding.UTF8, "application/json")).Result;

                string token = tokenResponse.Content.ReadAsStringAsync().Result;

                httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {token}");

                HttpResponseMessage actualsResponse = httpClient.GetAsync(
                    "https://dcol-ci-integrationapi-weu.ci.ase.dct.fasst.org.uk/api/v1.0/summarised-actuals/R02/ILR1920?pagesize=1000&PageNumber=2").Result;

                Assert.IsTrue(actualsResponse.IsSuccessStatusCode);

                string actualsContent = actualsResponse.Content.ReadAsStringAsync().Result;

                IReadOnlyCollection<SummarisedActual> actuals = JsonConvert.DeserializeObject<IReadOnlyCollection<SummarisedActual>>(actualsContent);

                Assert.IsNotNull(actuals);
                Assert.AreEqual(980, actuals.Count, "The number of items is incorrect");
            }
        }

        private class LoginCredentials
        {
            public string username { get; set; }

            public string password { get; set; }
        }

        private class Collection
        {
            public string collectionType { get; set; }

            public string collectionReturnCode { get; set; }

            public DateTime dateTime { get; set; }

            public int TotalItems { get; set; }
        }

        private class SummarisedActual
        {
            public string collectionType { get; set; }

            public string collectionReturnCode { get; set; }

            public string organisationId { get; set; }

            public string periodTypeCode { get; set; }

            public string period { get; set; }

            public string fundingStreamPeriodCode { get; set; }

            public string contractAllocationNumber { get; set; }

            public string uopCode { get; set; }

            public string deliverableCode { get; set; }

            public long actualVolume { get; set; }

            public double actualValue { get; set; }
        }
    }
}
