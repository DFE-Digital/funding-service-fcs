namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using MoreLinq;
    using Newtonsoft.Json;

    public static class CfsStubRepository
    {
        private static readonly string UnsuffixedTableName = "CfsStub";
        private static readonly string EnvironmentSuffixedTableName;

        static CfsStubRepository()
        {
            EnvironmentSuffixedTableName = $"{UnsuffixedTableName}{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(EnvironmentSuffixedTableName);
        }

        public static void RemoveAll()
        {
            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.DeleteAllRows<CfsStubEntity>(EnvironmentSuffixedTableName);
        }

        public static void AddRange(IEnumerable<DTO.Cfs.FundingAllocation> allocations)
        {
            AzureTableStore azureTableStore = new AzureTableStore();

            allocations
                .Select((a, i) =>
                {
                    a.PageNumber = i + 1;
                    return CfsStubEntity.Create(a);
                })
                .ForEach(se => azureTableStore.CreateRow(EnvironmentSuffixedTableName, se));
        }

        private class CfsStubEntity : TableEntity
        {
            public string SerializedAllocation { get; set; }

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
