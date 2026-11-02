namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Net;
    using System.Net.Http;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Dtos;
    using System.Text;
    using Newtonsoft.Json;
    using System.Data.SqlClient;
    using Dapper;
    using System.Configuration;

    [TestClass]
    public class DasEventsControllerTests
    {
        private const string OrganisationDoesNotExistErrorMessage = "Organisation does not exist";
        private const string TradingNameIsIncorrectErrorMessage = "Trading Name is incorrect";

        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);
        // toggle to BaseUrl below when debugging
        //private static readonly Uri BaseUrl = new Uri("http://localhost:3597/");

        private static string OrganisationConnectionString => ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;
        private static string ContractManagementConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;


        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishProviderController_InitiatePublication_ShouldRespondWithHttpStatusCodeOk()
        {
            // arrange
            const string ukprn = "123456781";
            const string tradingName = "tradingName";
            const string url = "/dasevents/initiatepublication";

            RemoveOrganisation(ukprn);
            AddOrganisation(ukprn, tradingName);

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                var command = JsonConvert.SerializeObject(new OrganisationInfo(ukprn, tradingName));
                var stringContent = new StringContent(command, Encoding.UTF8, "application/json");

                // act
                var httpResponseMessage = http.PostAsync(url, stringContent).Result;

                // assert
                Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The IsSuccessStatusCode is incorrect");
                Assert.AreEqual(HttpStatusCode.Created, httpResponseMessage.StatusCode, "The status code is incorrect");
            }

            RemoveOrganisation(ukprn);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishProviderController_InitiatePublication_ShouldRespondWithHttpStatusCodeBadrequestAndReturnsOrganisationDoesNotExistMessage()
        {
            // arrange
            const string ukprn = "123456781";
            const string tradingName = "tradingName";
            const string url = "/dasevents/initiatepublication";

            RemoveOrganisation(ukprn);

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                var command = JsonConvert.SerializeObject(new OrganisationInfo(ukprn, tradingName));
                var stringContent = new StringContent(command, Encoding.UTF8, "application/json");

                // act
                var httpResponseMessage = http.PostAsync(url, stringContent).Result;

                // assert
                Assert.IsFalse(httpResponseMessage.IsSuccessStatusCode, "The IsSuccessStatusCode is incorrect");
                Assert.AreEqual(HttpStatusCode.BadRequest, httpResponseMessage.StatusCode, "The status code is incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PublishProviderController_Recent_ShouldRespondWithHttpStatusCodeOk()
        {
            // arrange
            const string url = "/dasevents/recent";
            const int eventId = -8800;

            RemoveEngagementEvent(eventId);
            AddEngagementEvent(eventId);

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponseMessage = http.GetAsync(url).Result;

                // assert
                Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The IsSuccessStatusCode is incorrect");
                var responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
                Assert.IsTrue(responseBody.Contains("-8800"), "The response does not contain the expected eventId");
            }

            RemoveEngagementEvent(eventId);
        }

        public void AddOrganisation(string ukprn, string tradingName)
        {
            using (var connection = new SqlConnection(OrganisationConnectionString))
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
            using (var connection = new SqlConnection(OrganisationConnectionString))
            {
                const string sql = @"DELETE FROM [Organisation].[Organisation] WHERE Ukprn = @ukprn";

                connection.Execute(sql, new { ukprn });
            }
        }
        
        public void RemoveEngagementEvent(int eventId)
        {
            using (var connection = new SqlConnection(ContractManagementConnectionString))
            {
                const string sql = @"DELETE FROM [ContractManagement].[EngagementEvent] WHERE [EventId] = @eventId";

                connection.Execute(sql, param: new { eventId });
            }
        }

        private static void AddEngagementEvent(int eventId)
        {
            using (var connection = new SqlConnection(ContractManagementConnectionString))
            {
                const string sql = @"INSERT INTO [ContractManagement].[EngagementEvent] ([EventId]
                                       ,[EventType]
                                       ,[ProviderId]
                                       ,[ProcessingState]) values (@eventId, 'INITIATED', 99999, 5);";

                connection.Execute(sql, param: new { eventId });
            }
        }
    }
}