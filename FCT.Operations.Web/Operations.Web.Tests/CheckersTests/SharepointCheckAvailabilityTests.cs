
namespace Operations.Web.Tests.CheckersTests
{
    using System.Threading.Tasks;
    using Checkers;                // Operations.Web.Checkers
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Services; // SharepointAuthHelper

    [TestClass]
    public class SharepointCheckAvailabilityTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task SharepointCheckAvailability_OAuth_ShouldReturnPositiveIfSharepointIsAvailable()
        {
            // arrange: keep the same signature (delegate is not used by the Graph checker internally)
            var checker = new SharepointCheckAvailability(SharepointAuthHelper.GetOAuthContext, "Sharepoint");

            // act
            var actualResult = await checker.GetCheckResult();

            // assert
            Assert.IsTrue(
                actualResult.IsAvailable,
                $"Failed to connect to SharePoint. Details: {actualResult.Details ?? "<none>"}"
                + (string.IsNullOrWhiteSpace(actualResult.SupplementaryInfo) ? "" : $" | Info: {actualResult.SupplementaryInfo}")
            );
        }
    }
}
