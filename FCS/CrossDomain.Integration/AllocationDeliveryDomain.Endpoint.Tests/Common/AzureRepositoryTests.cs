namespace AllocationDeliveryDomain.Endpoint.Tests.Common
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class AzureRepositoryTests : IntegrationTestBase
    {
        const string CollectionType = "XX";
        const string CollectionReturnCode = "11";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ShouldUpdateARowWhenItAlreadyExists()
        {
            // arrange
            var repository = Container.Resolve<IAzureRepository<ActualsCollectionTypeSummary>>();
            var entity = new ActualsCollectionTypeSummary(CollectionType, CollectionReturnCode, 100);
            
            // act
            repository.AddRowOrUpdate(entity);
            var row = repository.GetRow(CollectionType, CollectionReturnCode);
            row.CurrentNumberOfRows = 101;
            repository.AddRowOrUpdate(row);
            row = repository.GetRow(CollectionType, CollectionReturnCode);

            // assert
            Assert.IsTrue(row.CurrentNumberOfRows == 101);
        }

        [TestCleanup, TestInitialize]
        public void CleanUp()
        {
            var repository = Container.Resolve<IAzureRepository<ActualsCollectionTypeSummary>>();
            repository.DeleteRows(CollectionType);
        }
    }
}
