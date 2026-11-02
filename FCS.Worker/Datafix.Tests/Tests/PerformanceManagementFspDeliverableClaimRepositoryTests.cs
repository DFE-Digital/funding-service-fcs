namespace Datafix.Tests.Tests
{
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PerformanceManagementFspDeliverableClaimRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void PerformanceManagementFspDeliverableClaimRepository_ShouldInsert()
        {
            PerformanceManagementFspDeliverableClaimRepository.InsertDeliverable(
                "TestFsp",
                101,
                true,
                "19TRN2020-LS2021",
                "deliverableName",
                1,
                true);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PerformanceManagementFspDeliverableClaimRepository_ShouldDelete()
        {
            PerformanceManagementFspDeliverableClaimRepository.RemoveDeliverableFromFsp(
                "TestFsp",
                101);
        }
    }
}
