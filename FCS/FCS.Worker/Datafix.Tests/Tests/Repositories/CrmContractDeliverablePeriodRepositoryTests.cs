namespace Datafix.Tests.Tests.Repositories
{
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmContractDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmContractDeliverablePeriodRepository_ShouldGetData()
        {
            var ids = CrmContractDeliverablePeriodRepository.GetCdpIdsLatestAllocation("LEVY-5186", 8, "Aug-21");
            Assert.AreEqual(1, ids.Count);
        }
    }
}
