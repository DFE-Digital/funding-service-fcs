namespace ContractManagementService.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Azure.Data.Tables;
    using SFA.FCS.Worker.Common;

    public class AzureTableStorageRepository : IAzureTableStorageRepository
    {
        private readonly IFcsConfiguration _configuration;

        public AzureTableStorageRepository(IFcsConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new()
        {
            var tableServiceClient = await GetTableServiceClient(tablename);
            var tasks = entities.Select(e => tableServiceClient.AddEntityAsync(e));

            await Task.WhenAll(tasks);
        }

        public async Task DeleteAllRowsInPartition<T>(string tablename, string partitionKey) where T : class, ITableEntity, new()
        {
            var tableServiceClient = await GetTableServiceClient(tablename);
            var oDataQueryEntities = tableServiceClient.Query<T>(filter: TableClient.CreateQueryFilter($"PartitionKey eq {partitionKey}"));

            var deleteTasks =
                oDataQueryEntities.Select(e => tableServiceClient.DeleteEntityAsync(partitionKey, e.RowKey));

            await Task.WhenAll(deleteTasks);
        }

        public async Task<IEnumerable<T>> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new()
        {
            var tableServiceClient = await GetTableServiceClient(tablename);
            var oDataQueryEntities =  tableServiceClient.Query<T>(filter: TableClient.CreateQueryFilter($"PartitionKey eq {partitionKey}"));

            return oDataQueryEntities.Select(e => e).ToList();
        }

        public void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {

        }

        public void CreateTableIfNotExists(string tableName)
        {

        }

        private async Task<TableClient> GetTableServiceClient(string tableName)
        {
            var storageConnectionString = _configuration["ConnectionStrings:StorageConnectionString"];
            TableClient tableClient = new TableClient(storageConnectionString, tableName);
            await tableClient.CreateIfNotExistsAsync();

            return tableClient;
        }
    }

    public interface IAzureTableStorageRepository
    {
        Task CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new();
        Task DeleteAllRowsInPartition<T>(string tablename, string partition) where T : class, ITableEntity, new();
        Task<IEnumerable<T>> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new();
        void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new();
        void CreateTableIfNotExists(string tableName);
    }
}
