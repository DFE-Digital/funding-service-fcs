namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    // using Microsoft.WindowsAzure.Storage.Table;
    using Azure;
    using Azure.Data.Tables;
    using CrossDomain.Integration.Common.Storage;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;


    public static class GatewayServiceStubRepository
    {
        private const string UnSuffixedTableName = "GatewayServiceStub";
        private const string PartitionKey = "GatewayServiceStubPartitionKey";
        private static readonly string EnvironmentSuffixedTableName;

        static GatewayServiceStubRepository()
        {
            EnvironmentSuffixedTableName = $"{UnSuffixedTableName}{TestConfiguration.Configuration["StorageTableSuffix"]}";
            IAzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(EnvironmentSuffixedTableName);
        }

        public static void Add(int ukprn, string status)
        {
            IAzureTableStore azureTableStore = new AzureTableStore();

            azureTableStore.CreateRow(EnvironmentSuffixedTableName, new GatewayServiceStubEntity
            {
                PartitionKey = PartitionKey,
                RowKey = ukprn.ToString(),
                Ukprn = ukprn.ToString(),
                Status = status
            });
        }

        public static void RemoveByUkprn(int ukprn)
        {
            IAzureTableStore azureTableStore = new AzureTableStore();

            IEnumerable<GatewayServiceStubEntity> rows = azureTableStore.GetRows<GatewayServiceStubEntity>(EnvironmentSuffixedTableName, PartitionKey);
            if (rows.Any(r => r.Ukprn == ukprn.ToString()))
            {
                azureTableStore.DeleteRow(EnvironmentSuffixedTableName, PartitionKey, ukprn.ToString());
            }
        }

        private class GatewayServiceStubEntity : ITableEntity
        {
            public string Ukprn { get; set; }

            public string Status { get; set; }

            public string PartitionKey { get; set; }

            public string RowKey { get; set; }

            public DateTimeOffset? Timestamp { get; set; }

            public ETag ETag { get; set; }

        }
    }
}
