namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using Dapper;
    using Dtos;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;

    [TestClass]
    public class CheckerControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckerController_GetCheckers_ShouldGetListOfServiceNames()
        {
            // arrange
            string url = "/availability/services";
            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The status code is not a success");
            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            Assert.IsTrue(responseBody.Contains("Cpds"), "The response does not contain an expected service name");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckerController_GetCheckResult_ShouldGetAvailabilityOfAService()
        {
            // arrange
            const string serviceName = "Cpds";
            ClearServiceFromTable(serviceName);
            InsertRowIntoTable(serviceName, canConnect: true, null);

            string url = $"/availability/services/{serviceName}";
            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "Request was not successful");

            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            AvailabilityCheckResult result = JsonConvert.DeserializeObject<AvailabilityCheckResult>(responseBody);

            Assert.IsNotNull(result, "No availability check result was returned");
            Assert.AreEqual(serviceName.ToUpper(), result.ServiceName.ToUpper(), "Service name was not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckerController_GetCheckResult_ShouldReturnNotFoundIfInvalidServiceName()
        {
            // arrange
            const string serviceName = "ServiceThatDoesNotExist";

            string url = $"/availability/services/{serviceName}";
            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsFalse(httpResponseMessage.IsSuccessStatusCode, "Request should not be successful");
            Assert.AreEqual(HttpStatusCode.NotFound, httpResponseMessage.StatusCode, "Status code was not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckerController_GetCheckers_ShouldNotBringBackUnintentionalHttpHeaders()
        {
            // arrange
            string url = "/availability/services";
            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.IsFalse(httpResponseMessage.Headers.Contains("X-Powered-By"), "The headers should not contain 'X-Powered-By'");
            Assert.IsFalse(httpResponseMessage.Headers.Contains("X-AspNet-Version"), "The headers should not contain 'X-AspNet-Version'");
            Assert.IsTrue(httpResponseMessage.Headers.Server.Empty(), "The Server items in the header should be empty");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CheckerController_GetCheckers_ShouldBringBackSecurityHttpHeaders()
        {
            // arrange
            string url = "/availability/services";
            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            var securityHeaders = new List<(string headerKey, string value)>
            {
                ("X-Frame-Options", "SAMEORIGIN"),
                ("X-XSS-Protection", "0"),
                ("X-Content-Type-Options", "nosniff"),
                ("Strict-Transport-Security", "max-age=63072000; includeSubdomains; preload")
            };

            securityHeaders.ForEach(securityHeader =>
            {
                httpResponseMessage.Headers.TryGetValues(securityHeader.headerKey, out var headerValues);
                headerValues = headerValues ?? new List<string>();

                Assert.IsTrue(headerValues.Any(), $"The header: {securityHeader.headerKey} is not present");
                Assert.AreEqual(securityHeader.value, headerValues.Single(),  $"The header: {securityHeader.headerKey} has the wrong value");
            });
        }

        private static string ContractManagementConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        private void InsertRowIntoTable(string serviceName, bool canConnect, string suppInfo)
        {
            SqlConnection connection = new SqlConnection(ContractManagementConnectionString);

            const string sql = @"insert into [Operations].[Connectivity] ([ServiceName]
      ,[CanConnect]
      ,[ErrorInfo]
      ,[SupplementaryInfo]
      ,[LastUpdated])
      values (@serviceName, @canConnect, @errorInfo, @suppInfo, @now)";
            const string errorInfo = null;
            DateTime now = DateTime.Now;

            connection.Execute(sql, new { serviceName, canConnect, errorInfo, suppInfo, now });
        }

        private void ClearServiceFromTable(string serviceName)
        {
            SqlConnection connection = new SqlConnection(ContractManagementConnectionString);

            const string sql = "delete from [Operations].[Connectivity] where ServiceName=@serviceName";

            connection.Execute(sql, new { serviceName });
        }
    }
}