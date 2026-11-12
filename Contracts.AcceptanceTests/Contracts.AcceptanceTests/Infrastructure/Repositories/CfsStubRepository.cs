namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using Azure;
    using Azure.Data.Tables;
    using CrossDomain.Integration.Common.Storage;
    //using Microsoft.WindowsAzure.Storage.Table;
    using MoreLinq;
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class CfsStubRepository
    {
        private static readonly string UnsuffixedTableName = "CfsStub";
        private static readonly string EnvironmentSuffixedTableName;

        static CfsStubRepository()
        {
            EnvironmentSuffixedTableName = $"{UnsuffixedTableName}{TestConfiguration.Configuration["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore(StorageConnectionStringProvider.Get());
            azureTableStore.CreateTableIfNotExists(EnvironmentSuffixedTableName);
        }

        public static void RemoveAll()
        {
            AzureTableStore azureTableStore = new AzureTableStore(StorageConnectionStringProvider.Get());
            azureTableStore.DeleteAllRows<CfsStubEntity>(EnvironmentSuffixedTableName);
        }

        public static void AddRange(IEnumerable<DTO.Cfs.FundingAllocation> allocations)
        {
            AzureTableStore azureTableStore = new AzureTableStore(StorageConnectionStringProvider.Get());

            allocations
                .Select((a, i) =>
                {
                    a.PageNumber = i + 1;
                    return CfsStubEntity.Create(a);
                })
                .ForEach(se => azureTableStore.CreateRow(EnvironmentSuffixedTableName, se));
        }

        private class CfsStubEntity : ITableEntity
        {
            public string SerializedAllocation { get; set; }
            public string PartitionKey { get; set; }

            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag { get; set; }

            public static CfsStubEntity Create(DTO.Cfs.FundingAllocation allocation)
            {
                CfsStubEntity stubEntity = new CfsStubEntity
                {
                    PartitionKey = allocation.FundingId,
                    RowKey = allocation.FundingVersion,
                    SerializedAllocation = JsonConvert.SerializeObject(allocation)
                };

                return stubEntity;
            }
        }
    }
}
