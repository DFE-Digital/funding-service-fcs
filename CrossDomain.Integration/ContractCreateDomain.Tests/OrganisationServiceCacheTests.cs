namespace ContractCreateDomain.Tests
{
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class OrganisationServiceCacheTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void GetOrganisationForUkprn_ShouldCallOrganisationServiceGetOrganisationOnlyWhenUkprnIsNotInTheCache()
        {
            // Arrange 
            Mock<IOrganisationService> orgServiceMock = new Mock<IOrganisationService>();
            orgServiceMock.Setup(o => o.GetOrganisationForUkprn(It.IsAny<int>())).Returns(new organisation());

            OrganisationServiceCache organisationServiceCache = new OrganisationServiceCache(orgServiceMock.Object);

            // Act
            organisationServiceCache.GetOrganisationForUkprn(111111111);
            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(1), "GetOrganisationForUkprn was not called. Ukprn '111111111' is NOT IN the cache");

            // Act
            organisationServiceCache.GetOrganisationForUkprn(111111111);
            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(1), "GetOrganisationForUkprn was called. Ukprn '111111111' is IN the cache");

            // Act
            organisationServiceCache.GetOrganisationForUkprn(222222222);
            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(2), "GetOrganisationForUkprn was not called. Ukprn '222222222' is NOT IN the cache");

            // Act
            organisationServiceCache.GetOrganisationForUkprn(222222222);
            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(2), "GetOrganisationForUkprn was called. Ukprn '222222222' is IN the cache");

            // Act
            organisationServiceCache.GetOrganisationForUkprn(33333333);
            // Assert
            orgServiceMock.Verify(c => c.GetOrganisationForUkprn(It.IsAny<int>()), Times.Exactly(3), "GetOrganisationForUkprn was not called. Ukprn '33333333' is NOT IN the cache");

        }
    }
}