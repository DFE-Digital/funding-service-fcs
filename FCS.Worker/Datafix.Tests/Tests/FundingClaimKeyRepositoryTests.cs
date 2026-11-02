namespace Datafix.Tests.Tests
{
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;

    [TestClass]
    public class FundingClaimKeyRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingClaimKeyRepository_GetKeys_ShouldReturnKeys()
        {
            FundingClaimKeyRepository repository = new FundingClaimKeyRepository();

            var keys = repository.GetKeys("2021", "YEAREND");

            Assert.IsTrue(keys.Count > 0);
        }
    }
}
