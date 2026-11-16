namespace Operations.Web.Tests.CheckersTests
{
    using System;
    using System.Collections.ObjectModel;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Checkers;
    using Dtos;
    using Enums;
    using Microsoft.IdentityModel.Clients.ActiveDirectory;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Services;

    [TestClass]
    public class FeedReadCheckAvailabilityTests
    {
        private const string AuthenticationResultJson =
        @"{
	        ""AccessToken"": ""YOUR ACCESS TOKEN HERE"",
	        ""AccessTokenType"": ""Bearer"",
	        ""ExpiresOn"": {
		        ""DateTime"": ""\/Date(1508517838612)\/"",
		        ""OffsetMinutes"": 0
	        },
	        ""IdToken"": null,
	        ""IsMultipleResourceRefreshToken"": false,
	        ""RefreshToken"": null,
	        ""TenantId"": null,
	        ""UserInfo"": null
        }";

        private const ServiceInterface TestServiceEnum = ServiceInterface.ContractFeed;

        private readonly AuthenticationRequest _testAuthenticationRequest = new AuthenticationRequest("testAadInstance", "testTenant", "testClientId", "testAppKey", "testResourceId");

        private readonly ReadOnlyCollection<MediaTypeWithQualityHeaderValue> _testMediaHeaderCollection = new ReadOnlyCollection<MediaTypeWithQualityHeaderValue>(
            new[] { new MediaTypeWithQualityHeaderValue("application/json") });


        [TestMethod, TestCategory("UnitTest")]
        public void FeedReaderCheckAvailability_WhenHttpRequestIsNotSuccessful_ShouldSurfaceFailureMessage()
        {
            // arrange
            string errorMessage = "A mock error occurred";
            
            Mock<IHttpUtility> mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = false,
                Message = errorMessage
            }));

            Mock<IAuthenticationHelper> mockAuthenticationHelper = new Mock<IAuthenticationHelper>();
            mockAuthenticationHelper.Setup(ah => ah.GetAuthenticationResult(It.IsAny<AuthenticationRequest>())).Returns(AuthenticationResultJson);

            var checkerHttpRequestInformation = new CheckerHttpRequestInformation(TestServiceEnum, "testBaseUrl", "testPageToCheck", _testMediaHeaderCollection, _testAuthenticationRequest);

            FeedReadCheckAvailability feedChecker = new FeedReadCheckAvailability(mockHttp.Object, mockAuthenticationHelper.Object, checkerHttpRequestInformation);

            // act
            var result = feedChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsFalse(result.IsAvailable, "result was incorrrectly available.");
            Assert.AreEqual(errorMessage, result.Details, "error message is wwrong.");
            Assert.AreEqual("ContractFeed", result.ServiceName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FeedReaderCheckAvailability_WhenHttpRequestIsSuccessful_ShouldSurfaceSuccessMessage()
        {
            // arrange
            string successMessage = "Http request successful";
            
            Mock<IHttpUtility> mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = true,
                Message = successMessage
            }));

            Mock<IAuthenticationHelper> mockAuthenticationHelper = new Mock<IAuthenticationHelper>();
            mockAuthenticationHelper.Setup(ah => ah.GetAuthenticationResult(It.IsAny<AuthenticationRequest>())).Returns(AuthenticationResultJson);

            var checkerHttpRequestInformation = new CheckerHttpRequestInformation(TestServiceEnum, "testBaseUrl", "testPageToCheck", _testMediaHeaderCollection, _testAuthenticationRequest);

            FeedReadCheckAvailability feedChecker = new FeedReadCheckAvailability(mockHttp.Object, mockAuthenticationHelper.Object, checkerHttpRequestInformation);

            // act
            var result = feedChecker.GetCheckResult().GetAwaiter().GetResult();


            // assert
            Assert.IsTrue(result.IsAvailable, "result was incorrrectly available.");
            Assert.AreEqual(successMessage, result.Details, "success message is wwrong.");
            Assert.AreEqual("ContractFeed", result.ServiceName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FeedReaderCheckAvailability_WhenHttpRequestIsUnsuccessfulWithExceptionThrown_ShouldSurfaceExceptionMessage()
        {
            // arrange
            string exceptionMessage = "Http request exception";

            Mock<IHttpUtility> mockHttp = new Mock<IHttpUtility>();
            mockHttp.Setup(m => m.Get(It.IsAny<string>())).Returns(Task.FromResult(new HttpResult
            {
                IsSuccess = false,
                Message = exceptionMessage
            }));

            Mock<IAuthenticationHelper> mockAuthenticationHelper = new Mock<IAuthenticationHelper>();
            mockAuthenticationHelper
                .Setup(ah => ah.GetAuthenticationResult(It.IsAny<AuthenticationRequest>()))
                .Throws(new TimeoutException(exceptionMessage));

            var checkerHttpRequestInformation =
                new CheckerHttpRequestInformation(
                    ServiceInterface.DeliverableSettingFeed,
                    "testBaseUrl",
                    "testPageToCheck",
                    _testMediaHeaderCollection,
                    _testAuthenticationRequest);

            FeedReadCheckAvailability feedChecker =
                new FeedReadCheckAvailability(
                    mockHttp.Object,
                    mockAuthenticationHelper.Object,
                    checkerHttpRequestInformation);

            // act
            var result = feedChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsFalse(result.IsAvailable);
            Assert.AreEqual(exceptionMessage, result.Details);
            Assert.AreEqual("DeliverableSettingFeed", result.ServiceName);
        }
    }
}
