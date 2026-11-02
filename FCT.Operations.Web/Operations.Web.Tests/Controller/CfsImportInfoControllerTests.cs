namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Configuration;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using FluentAssertions;

    [TestClass]
    public class CfsImportInfoControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsImportInfoController_ShouldGetOkBack()
        {
            // arrange
            const string url = "/cfs-import/infos?pageNumber=1";

            HttpResponseMessage httpResponseMessage;

            // act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            httpResponseMessage.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}