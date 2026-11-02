namespace Operations.Web.Tests.CheckersTests
{
    using Checkers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;

    [TestClass]
    public class CfsProviderApiCheckAvailabilityTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsProviderApiCheckAvailability_ShouldReturnIsAvailable()
        {
            // arrange
            var cfsNotificationFeedChecker = new CfsProviderApiCheckAvailability(new ConnectivityRepository());

            // act
            var result = cfsNotificationFeedChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(result.IsAvailable);
        }
    }
}