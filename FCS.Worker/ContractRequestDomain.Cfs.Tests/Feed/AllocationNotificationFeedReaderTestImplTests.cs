namespace ContractRequestDomain.Cfs.Tests.Feed
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Cfs.Feed.Dtos;
    using Cfs.Feed.Services;
    using Cfs.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class AllocationNotificationFeedReaderTestImplTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CfsFeedReaderTestImpl_ShouldReturnAllocationNotificationsFromStubStorageInCorrectOrder()
        {
            // arrange
            string stubTableName = $"CfsStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(stubTableName);
            azureTableStore.DeleteAllRows<CfsStubEntity>(stubTableName);

            Enumerable.Range(1, 20).ForEach(i => azureTableStore.CreateRow(stubTableName, new CfsStubEntity
            {
                PartitionKey = i.ToString(),
                RowKey = "1",
                StubId = i,
                AllocationId = i.ToString(),
                VersionNumber = i,
                Ukprn = i
            }));

            AllocationNotificationFeedReaderTestImpl allocationNotificationFeedReaderTestImpl = new AllocationNotificationFeedReaderTestImpl();

            // act
            AtomPage atomPage = allocationNotificationFeedReaderTestImpl.GetAtomPage(It.IsAny<int>());

            // assert
            Assert.IsNotNull(atomPage, "Return result was null");
            Assert.AreEqual(20, atomPage.AtomEntry.Length, "Unexpected number of atomEntry elements returned");

            List<string> atomEntryIds = atomPage.AtomEntry.Select(e => e.Id).ToList();

            Enumerable.Range(1, 20).ForEach(i => Assert.IsNotNull(atomEntryIds.SingleOrDefault(id => id == i.ToString()), "Not all allocations were returned"));
            Assert.AreEqual("1", atomEntryIds.First(), "First AllocationId was incorrect");
            Assert.AreEqual("20", atomEntryIds.Last(), "Last AllocationId was incorrect");
        }
    }
}
