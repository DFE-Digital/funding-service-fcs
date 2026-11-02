namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Configuration;
    using System.Net;
    using System.Net.Http;
    using FluentAssertions;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ParkedFundingAllocationsControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void ParkedFundingAllocationsController_Details_ShouldRespondWithHttpStatusCodeOk()
        {
            // arrange
            const string url = "/parked-funding-allocations/detail";

            HttpResponseMessage httpResponseMessage;

            //act
            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                httpResponseMessage = http.GetAsync(url).Result;
            }

            // assert
            httpResponseMessage.StatusCode.Should().Be(HttpStatusCode.OK);
        }
    }
}