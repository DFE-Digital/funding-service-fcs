namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using System.Data.SqlClient;
    using Dtos;
    using Dapper;

    [TestClass]
    public class OrganisationControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        private static string ConnectionString => ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationController_id_ShouldRespondWithHttpStatusCodeOkAndOrganisationInfo()
        {
            // arrange
            const string ukprn = "123456781";
            const string tradingName = "tradingName";
            string url = $"/fcs-organisation/{ukprn}";

            RemoveOrganisation(ukprn);
            AddOrganisation(ukprn, tradingName);

            HttpResponseMessage httpResponseMessage;

            //act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The status code is not a success");
            Assert.AreEqual(HttpStatusCode.OK, httpResponseMessage.StatusCode, "The status code is not OK");

            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            var organisationInfo = JsonConvert.DeserializeObject<OrganisationInfo>(responseBody);

            Assert.AreEqual(tradingName, organisationInfo.TradingName, "The tradingName is not correct");
            Assert.AreEqual(ukprn, organisationInfo.Ukprn, "The ukprn is not correct");

            RemoveOrganisation(ukprn);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void OrganisationController_id_ShouldRespondWithHttpStatusCodeNotFound()
        {
            // arrange
            const string ukprn = "123456781";
            //const string tradingName = "tradingName";
            string url = $"/fcs-organisation/{ukprn}";

            RemoveOrganisation(ukprn);

            HttpResponseMessage httpResponseMessage;

            //act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsFalse(httpResponseMessage.IsSuccessStatusCode, "The status code is not a success");
            Assert.AreEqual(HttpStatusCode.NotFound, httpResponseMessage.StatusCode, "The status code is not NotFound");
        }

        public void AddOrganisation(string ukprn, string tradingName)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"INSERT INTO[Organisation].[Organisation]
                                        ([Ukprn]
                                        ,[Upin]
                                        ,[SequenceNumber]
                                        ,[TradingName]
                                        ,[HasUkrlpBeenCalledSuccessfully])
                                    VALUES
                                        (@ukprn, @upin, 1, @tradingName, 1)";

                connection.Execute(sql, new { ukprn, upin = ukprn, tradingName });
            }
        }

        public void RemoveOrganisation(string ukprn)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE FROM [Organisation].[Organisation] WHERE Ukprn = @ukprn";

                connection.Execute(sql, new { ukprn });
            }
        }
    }
}