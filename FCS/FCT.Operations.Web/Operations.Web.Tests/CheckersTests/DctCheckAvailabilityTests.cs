namespace Operations.Web.Tests.CheckersTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Checkers;
    using Services;
    using System.Configuration;
    using System.Threading.Tasks;
    using Dtos;
    using Moq;

    [TestClass]
    public class DctCheckAvailabilityTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DctCheckAvailability_ShouldSurfaceFailureMessage()
        {
            // arrange
            const string errorMessage = "A mock error occurred";

            var mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = false,
                Message = errorMessage
            }));

            var dctChecker = new DctCheckAvailability(mockHttp.Object, Mock.Of<IOAuthAccessTokenFactoryDct>());

            // act
            var result = dctChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsFalse(result.IsAvailable, "result was incorrectly available");
            Assert.AreEqual(errorMessage, result.Details, "error message is wrong");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DctCheckAvailability_ShouldShowSuccessIfUtilityIsSuccessful()
        {
            // arrange
            var mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = true,
            }));

            var dctChecker = new DctCheckAvailability(mockHttp.Object, Mock.Of<IOAuthAccessTokenFactoryDct>());

            // act
            var result = dctChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(result.IsAvailable, "result is incorrectly unavailable");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DctCheckAvailability_ShouldSendRequestToCorrectUrlWithSecretKey()
        {
            // arrange
            const string url = "mockurl";
            const string key = "abc123";

            ConfigurationManager.AppSettings.Set("DCT:Url", url);
            ConfigurationManager.AppSettings.Set("DCT:Oauth:ClientSecret", key);

            var mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = true,
            }));

            var dctChecker = new DctCheckAvailability(mockHttp.Object, Mock.Of<IOAuthAccessTokenFactoryDct>());

            // act
            dctChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            mockHttp.Verify(m => m.SetAuthorizationHeader("Bearer", It.IsAny<string>()), Times.Once);
            mockHttp.Verify(m => m.Get(It.Is<string>(s => s.StartsWith(url))));
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DctCheckAvailability_ShouldGetPageFromPreProd()
        {
            // arrange
            ConfigurationManager.AppSettings["DCT:Oauth:ClientId"] = "5a3a8177-606b-433f-bbb6-de40f5f85329";
            ConfigurationManager.AppSettings["DCT:Oauth:Scope"] = "api://0176c049-ceea-4d25-a375-6b70d9dbae13/.default";
            ConfigurationManager.AppSettings["DCT:Oauth:ClientSecret"] = "";
            ConfigurationManager.AppSettings["DCT:Oauth:Tenant"] = "3aacc835-4b83-483d-841d-cd787f6f1486";
            ConfigurationManager.AppSettings["DCT:Url"] =
                "https://api-summarisedactuals.submitlearnerdatappbeta.fasst.org.uk";

            var dctChecker = new DctCheckAvailability(new HttpUtility(), new OAuthAccessTokenFactoryDct());

            // act
            var result = dctChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(result.IsAvailable);
        }
    }
}