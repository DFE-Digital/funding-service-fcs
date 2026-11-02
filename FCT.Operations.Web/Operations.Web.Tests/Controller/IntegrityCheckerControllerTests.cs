namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Tests.Helpers;
    [TestClass]
    public class IntegrityCheckerControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);
        /// <summary>
        /// This test works against DAT there is not a cloud service in CI for it so it won't work as an Integration Test
        /// </summary>
        [TestMethod, TestCategory("TechnicalExploration")]
        public void IntegrityCheckerController_ShouldCreateIntegrityCheck()
        {
            // arrange
            string url = "/integrity-checker";
            HttpResponseMessage httpResponseMessage;
            const string integrityCheckToRun = "ANITA_PAAS_EXTRACT";
            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var content = new StringContent($"\"{integrityCheckToRun}\"", Encoding.UTF8, "application/json");
                httpResponseMessage = http.PostAsync(url, content).Result;
            }
            // assert
            Assert.AreEqual(HttpStatusCode.Accepted, httpResponseMessage.StatusCode, "The status code is not a correct");
        }
    }
}