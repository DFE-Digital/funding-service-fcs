namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using ContractRequestDomain.Cfs.Infrastructure;
    using Microsoft.WindowsAzure.Storage.Table;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public class AllocationDetailServiceTestImpl : IAllocationDetailService
    {
        public Task<Allocation> GetAllocationDetail(string allocationId, int version)
        {
            string stubTableName = $"CfsStub{ConfigurationManager.AppSettings["StorageTableSuffix"]}";

            AzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.CreateTableIfNotExists(stubTableName);

            CfsStubEntity cfsStubEntity = GetRow(azureTableStore: azureTableStore, tablename: stubTableName,
                partitionKey: allocationId, rowKey: version.ToString());

            Allocation allocation = JsonConvert.DeserializeObject<Allocation>(cfsStubEntity.SerializedAllocation);

            return Task.FromResult(allocation);
        }

        public CfsStubEntity GetRow(AzureTableStore azureTableStore, string tablename, string partitionKey, string rowKey)
        {
            var table = azureTableStore.GetTable(tablename);

            string queryString =
                TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey);
            string queryString2 =
                TableQuery.GenerateFilterCondition("RowKey", QueryComparisons.Equal, rowKey);
            string finalQuery = TableQuery.CombineFilters(queryString, TableOperators.And, queryString2);

            var query = new TableQuery<CfsStubEntity>().Where(finalQuery);

            TableQuerySegment<CfsStubEntity> segment = Task.Factory
                .FromAsync<TableQuery<CfsStubEntity>, TableContinuationToken, TableQuerySegment<CfsStubEntity>>(
                    table.BeginExecuteQuerySegmented,
                    table.EndExecuteQuerySegmented<CfsStubEntity>, query, null, null).Result;

            return segment.Results.SingleOrDefault();

            
            //var retrieveOperation = TableOperation.Retrieve<T>(partitionKey, rowKey, new );
            //return table.Execute(retrieveOperation).Result as T;
        }
    }
}
