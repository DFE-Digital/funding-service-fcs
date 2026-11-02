namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class NotificationsControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void NotificationController_GetNotifications_ShouldRespondWithHttpStatusCodeOk()
        {
            // arrange
            const string url = "fcs-notifications";
            HttpResponseMessage httpResponseMessage;

            //act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.AreEqual(HttpStatusCode.OK, httpResponseMessage.StatusCode, "The status code is not a success");
        }


        [TestMethod, TestCategory("DataDependent")]
        public void NotificationController_GetNotifications_ShouldRespondWithCorrectNotificationDescription()
        {
            // arrange
            const string url = "fcs-notifications";
            HttpResponseMessage httpResponseMessage;

            //act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            Assert.AreEqual(HttpStatusCode.OK, httpResponseMessage.StatusCode, "The status code is not a success");
            string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            Assert.IsTrue(responseBody.Contains("Item(s) on error queue"), "The notification description does not contain the expected text");
        }
    }
}