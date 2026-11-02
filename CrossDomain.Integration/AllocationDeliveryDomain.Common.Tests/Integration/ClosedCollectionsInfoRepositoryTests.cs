namespace AllocationDeliveryDomain.Common.Tests.Integration
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class ClosedCollectionsInfoRepositoryTests : IntegrationTestBase
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldAddRowIfNoPresent()
        {
            IClosedCollectionsInfoRepository repository = Container.Resolve<IClosedCollectionsInfoRepository>();
            repository.AddRowIfNotPresent();
            var row = repository.GetRow();
            Assert.IsTrue(row != null);
        }
    }
}
