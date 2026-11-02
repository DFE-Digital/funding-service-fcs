namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dto;
    using Microsoft.Extensions.Configuration;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class FundingNotificationApiTestImpl : IFundingNotificationApi
    {
        private readonly IConfigurationRoot _appConfiguration;

        public FundingNotificationApiTestImpl(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        public Task<CfsLatestPageData> GetLatestPageData()
        {
            var latestPageAtomItemsGrp = GetStubEntities()
                .Select(se => JsonConvert.DeserializeObject<AtomItem>(se.SerializedAllocation))
                .GroupBy(ai => ai.PageNumber)
                .OrderBy(grp => grp.Key)
                .Last();

            return Task.FromResult(new CfsLatestPageData(latestPageAtomItemsGrp.ToArray(), latestPageAtomItemsGrp.Key));
        }

        public Task<IReadOnlyCollection<AtomItem>> GetPage(int pageNumber)
        {
            var atomItems = GetStubEntities()
                .Select(se => JsonConvert.DeserializeObject<AtomItem>(se.SerializedAllocation))
                .Where(ai => ai.PageNumber == pageNumber)
                .OrderBy(ai => ai.PositionInPage)
                .ToList() as IReadOnlyCollection<AtomItem>;

            return Task.FromResult(atomItems);
        }

        public Task<ProviderFundingAllocationApiDto> GetProviderFundingAllocation(string providerFundingId)
        {
            var providerFunding = GetStubEntities()
                .Select(se => JObject.Parse(se.SerializedAllocation))
                .Select(jo => jo["ProviderFundingAllocations"])
                .SelectMany(jt => jt.ToObject<ProviderFundingAllocationApiDto[]>())
                .First(pfa => pfa.ProviderFundingId == providerFundingId);

            return Task.FromResult(providerFunding);
        }

        private IEnumerable<StubEntity> GetStubEntities()
        {
            CloudStorageAccount account = CloudStorageAccount.Parse(_appConfiguration.GetConnectionString("StorageConnectionString"));
            CloudTableClient tableClient = account.CreateCloudTableClient();
            CloudTable table = tableClient.GetTableReference("CfsStub" + _appConfiguration["StorageTableSuffix"]);
            TableQuery<StubEntity> query = new TableQuery<StubEntity>();
            TableContinuationToken continuationToken = null;

            List<StubEntity> results = new List<StubEntity>();
            do
            {
                TableQuerySegment<StubEntity> page = table.ExecuteQuerySegmentedAsync(query, continuationToken).Result;
                continuationToken = page.ContinuationToken;
                results.AddRange(page.Results);
            }
            while (continuationToken != null);

            return results;
        }

        private class StubEntity : TableEntity
        {
            public string SerializedAllocation { get; set; }
        }
    }
}
