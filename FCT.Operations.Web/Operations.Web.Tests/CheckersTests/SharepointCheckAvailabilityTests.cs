namespace Operations.Web.Tests.CheckersTests
{
    using System;
    using Checkers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;

    [TestClass]
    public class SharepointCheckAvailabilityTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SharepointCheckAvailability_OAuth_ShouldReturnPositiveIfSharepointIsAvailable()
        {
            // arrange
            var checker = new SharepointCheckAvailability(SharepointAuthHelper.GetOAuthContext, String.Empty);

            // act
            var actualResult = checker.GetCheckResult().Result;

            // assert
            Assert.IsTrue(actualResult.IsAvailable, "We have not been able to connect to Sharepoint");
        }
    }
}