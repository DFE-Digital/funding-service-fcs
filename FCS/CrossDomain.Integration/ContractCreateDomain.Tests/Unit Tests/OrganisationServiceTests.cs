namespace ContractCreateDomain.Tests.Unit_Tests
{
    using System.Net;
    using System.Net.Http;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.Framework.Logging.Interfaces;
    using UnitTests.Common;

    [TestClass]
    public class OrganisationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationService_When200OkResponseReceivedFromApiHttpClient_ShouldReturnOrganisation()
        {
            // arrange
            Mock<IOrganisationServiceApiHttpClient> apiHttpClientMock = new Mock<IOrganisationServiceApiHttpClient>();
            apiHttpClientMock
                .Setup(m => m.GetHttpResponseForUkprn(It.IsAny<int>()))
                .Returns(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.OK,
                    Content = new StringContent(TestResource.AsString("ContractCreateDomain.Tests.Resources", "organisation_corporate_schema.xml"))
                });

            OrganisationService organisationService = new OrganisationService(Mock.Of<ILogger>(), apiHttpClientMock.Object);

            // act
            organisation organisation = organisationService.GetOrganisationForUkprn(12345);

            // assert
            Assert.IsNotNull(organisation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationService_When404NotFoundResponseReceivedFromApiHttpClient_ShouldReturnNull()
        {
            // arrange
            Mock<IOrganisationServiceApiHttpClient> apiHttpClientMock = new Mock<IOrganisationServiceApiHttpClient>();
            apiHttpClientMock
                .Setup(m => m.GetHttpResponseForUkprn(It.IsAny<int>()))
                .Returns(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.NotFound
                });

            OrganisationService organisationService = new OrganisationService(Mock.Of<ILogger>(), apiHttpClientMock.Object);

            // act
            organisation organisation = organisationService.GetOrganisationForUkprn(12345);

            // assert
            Assert.IsNull(organisation);
        }
        
        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationService_When400BadRequestResponseReceivedFromApiHttpClientIndicatingMultipleActiveProvidersReturnedFromCpds_ShouldReturnNullAsIfProviderNotFound()
        {
            // arrange
            Mock<IOrganisationServiceApiHttpClient> apiHttpClientMock = new Mock<IOrganisationServiceApiHttpClient>();
            apiHttpClientMock
                .Setup(m => m.GetHttpResponseForUkprn(It.IsAny<int>()))
                .Returns(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.BadRequest
                });

            OrganisationService organisationService = new OrganisationService(Mock.Of<ILogger>(), apiHttpClientMock.Object);

            // act
            organisation organisation = organisationService.GetOrganisationForUkprn(12345);

            // assert
            Assert.IsNull(organisation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void OrganisationService_When500InternalErrorReturnedFromHttpApi_ShouldThrowException()
        {
            // arrange
            Mock<IOrganisationServiceApiHttpClient> apiHttpClientMock = new Mock<IOrganisationServiceApiHttpClient>();
            apiHttpClientMock
                .Setup(m => m.GetHttpResponseForUkprn(It.IsAny<int>()))
                .Returns(new HttpResponseMessage
                {
                    StatusCode = HttpStatusCode.InternalServerError
                });

            OrganisationService organisationService = new OrganisationService(Mock.Of<ILogger>(), apiHttpClientMock.Object);
            bool expectedExceptionThrown = false;

            // act
            try
            {
                organisationService.GetOrganisationForUkprn(12345);
            }
            catch (HttpRequestException)
            {
                expectedExceptionThrown = true;
            }

            // assert
            Assert.IsTrue(expectedExceptionThrown);
        }
    }
}
