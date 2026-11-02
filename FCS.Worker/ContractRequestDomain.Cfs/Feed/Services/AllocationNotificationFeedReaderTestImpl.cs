namespace ContractRequestDomain.Cfs.Feed.Services
{
    using System.Configuration;
    using System.Linq;
    using Dtos;
    using Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class AllocationNotificationFeedReaderTestImpl : IAllocationNotificationFeedReader
    {
        public AtomPage GetAtomPage(int pageNumber)
        {
            string stubTableName = $"CfsStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(stubTableName);

            return new AtomPage
            {
                Link = new[]
                {
                    // spoof feed having single page
                    new AtomLink { Href = "https://dummyurl?pageRef=1", Rel = "self"},
                    new AtomLink { Href = "https://dummyurl?pageRef=1", Rel = "last"}
                },
                AtomEntry = azureTableStore
                    .GetRows<CfsStubEntity>(stubTableName)
                    .OrderBy(e => e.StubId)
                    .Select(e => new AtomEntry
                    {
                        Id = e.AllocationId,
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = e.Ukprn },
                                AllocationVersionNumber = e.VersionNumber
                            }
                        }
                    })
                    .ToArray()
            };
        }
    }
}