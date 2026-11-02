namespace Operations.Web.Tests.Controller
{
    using System;
    using System.Configuration;
    using Helpers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MonthEndInfoControllerTests
    {
        private static readonly Uri BaseUrl = new Uri(ConfigurationManager.AppSettings["WebRoleUrl"]);

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractAtomInfoController_ShouldGetOkBack()
        {
            // arrange

            using (var http = HttpClientHelper.GetClientWithAuthorizedSession(BaseUrl))
            {
                // act
                var httpResponse = http.GetAsync("month-end/closed-collections?pageNumber=1").Result;
                // assert
                Assert.IsTrue(httpResponse.IsSuccessStatusCode);
            }
        }
    }
}
