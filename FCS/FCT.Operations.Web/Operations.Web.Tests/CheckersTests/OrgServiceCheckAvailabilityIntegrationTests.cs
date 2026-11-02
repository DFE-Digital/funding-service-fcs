namespace Operations.Web.Tests.CheckersTests
{
    using Checkers;
    using Dtos;
    using Enums;
    using Factory;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;

    [TestClass]
    public class OrgServiceCheckAvailabilityIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void OrgServiceCheckAvailability_ShouldConnect()
        {
            // arrange
            OrgServiceCheckAvailability orgServiceCheckAvailability = new OrgServiceCheckAvailability(
                new HttpUtility(),
                new AuthenticationHelper(),
                CheckerHttpRequestInformationFactory.GetAuthenticationForService(ServiceInterface.OrgService));

            // act
            AvailabilityCheckResult availabilityCheckResult = orgServiceCheckAvailability.GetCheckResult().Result;

            // assert
            Assert.AreEqual(true, availabilityCheckResult.IsAvailable);
        }
    }
}
