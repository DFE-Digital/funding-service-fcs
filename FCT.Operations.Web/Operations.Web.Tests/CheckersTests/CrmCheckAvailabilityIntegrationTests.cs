namespace Operations.Web.Tests.CheckersTests
{
    using Checkers;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmCheckAvailabilityIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmCheckAvailability_ShouldConnectToCrm()
        {
            // arrange
            CrmCheckAvailability crmCheckAvailability = new CrmCheckAvailability();

            // act
            AvailabilityCheckResult availabilityCheckResult = crmCheckAvailability.GetCheckResult().Result;

            // assert
            Assert.AreEqual(true, availabilityCheckResult.IsAvailable);
        }
    }
}
