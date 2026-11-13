namespace PerformanceManagementDomain.PullFundingClaim.Services
{
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using DTOs;
    using Azure;
    using Azure.Data.Tables;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;

    public class FundingClaimsApiStubAdapter : IFundingClaimsApiAdapter
    {
        private readonly IAzureTableStore _azureTableStore;
        private readonly string _tableName;

        public FundingClaimsApiStubAdapter(IAzureTableStore azureTableStore, IEnvironmentContext environmentContext)
        {
            _azureTableStore = azureTableStore;
            _tableName = $"FundingClaimApiStub{environmentContext.StorageTableSuffix}";
        }

        public int PageSize => 10;

        public Task<IReadOnlyCollection<string>> GetFundingClaimCompletedCollections(DateTime sinceDateTime)
        {
            var fundingClaimEntities = _azureTableStore.GetRows<FundingClaimApiEntity>(_tableName).ToList();
            var completedCollections = fundingClaimEntities.Select(f => f.PartitionKey).Distinct().ToList();

            return Task.FromResult((IReadOnlyCollection<string>)completedCollections);
        }

        public Task<int> GetCountOfFundingClaimsForCollectionKey(string dataCollectionKey)
        {
            var fundingClaimEntities = _azureTableStore.GetRows<FundingClaimApiEntity>(_tableName).ToList();

            return Task.FromResult(fundingClaimEntities.GroupBy(f => f.PartitionKey)
                .Single(grp => grp.Key == dataCollectionKey)
                .Count());
        }

        public Task<IReadOnlyCollection<FundingClaimApiDto>> GetFundingClaimsForCollectionKey(string dataCollectionKey, int pageNumber)
        {
            var fundingClaimEntities = _azureTableStore.GetRows<FundingClaimApiEntity>(_tableName).ToList();

            var fundingClaimsForPage = fundingClaimEntities.Select(e => JsonConvert.DeserializeObject<FundingClaimApiDto>(e.Json))
                .ToList();

            return Task.FromResult((IReadOnlyCollection<FundingClaimApiDto>)fundingClaimsForPage);
        }

        private class FundingClaimApiEntity : ITableEntity
        {
            public string PartitionKey { get; set; }
            public string RowKey { get; set; }
            public DateTimeOffset? Timestamp { get; set; }
            public ETag ETag { get; set; }

            public FundingClaimApiEntity()
            {
            }

            public FundingClaimApiEntity(string partitionKey, string rowKey, string json)
            {
                PartitionKey = partitionKey;
                RowKey = rowKey;
                Json = json;

            }
            public string Json { get; set; }

        }
    }
}
