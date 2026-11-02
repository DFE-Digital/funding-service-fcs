namespace Operations.Web.Tests.CheckersTests
{
    using Checkers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;

    [TestClass]
    public class CfsNotificationFeedCheckAvailabilityTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CfsNotificationFeedCheckAvailability_ShouldReturnIsAvailable()
        {
            // arrange
            var cfsNotificationFeedChecker = new CfsNotificationFeedCheckAvailability(new ConnectivityRepository());

            // act
            var result = cfsNotificationFeedChecker.GetCheckResult().GetAwaiter().GetResult();

            // assert
            Assert.IsTrue(result.IsAvailable);
        }
    }
}