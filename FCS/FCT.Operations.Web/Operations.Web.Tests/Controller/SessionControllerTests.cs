namespace Operations.Web.Tests.Controller
{
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class SessionControllerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SessionController_ShouldCreateSessionWhenAuthenticationTokenIsCorrect()
        {
            // arrange
            string url = $"{ConfigurationManager.AppSettings["WebRoleUrl"]}session";
            HttpResponseMessage httpResponseMessage = null;
            const string authenticationToken = "";

            using (var http = HttpConnectionFactory.GetAuthorizedHttpClient())
            {
                http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                // act
                httpResponseMessage = http.PostAsync(url, new StringContent($"\"{authenticationToken}\"", Encoding.UTF8, "application/json")).Result;
            }

            // assert
            Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The status code is not a success");
            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            Assert.IsTrue(responseBody.Contains("Token"), "the response does not contain a token");
        }

        [TestMethod, TestCategory("IntegrationTestWIP")]
        public void SessionController_ShouldCreateSessionWhenAuthenticationTokenIsCorrectAppService()
        {
            // arrange
            ConfigurationManager.AppSettings["WebRoleUrl"] = "https://fcs-dev-dat-app-x-opsweb.azurewebsites.net/";
//            ConfigurationManager.AppSettings["WebRoleUrl"] = "http://localhost:3597/";


            string url = $"{ConfigurationManager.AppSettings["WebRoleUrl"]}session";
            HttpResponseMessage httpResponseMessage = null;
            const string authenticationToken = ""; // we no longer need a token

            using (var http = HttpConnectionFactory.GetAuthorizedHttpClient())
            {
                http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                // act
                httpResponseMessage = http.PostAsync(url, new StringContent($"\"{authenticationToken}\"", Encoding.UTF8, "application/json")).Result;
            }

            // assert
            Assert.IsTrue(httpResponseMessage.IsSuccessStatusCode, "The status code is not a success");
            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            Assert.IsTrue(responseBody.Contains("Token"), "the response does not contain a token");
        }
    }
}
