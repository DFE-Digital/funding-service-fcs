namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using Azure;
    using Azure.Data.Tables;

    public class AzureTableStore : IAzureTableStore
    {
        private readonly string _storageConnectionString;

        public AzureTableStore()
            : this(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString)
        {
        }

        public AzureTableStore(string storageConnectionString)
        {
            _storageConnectionString = storageConnectionString;
        }

        public void CreateTableIfNotExists(string tablename)
        {
            GetTable(tablename);
        }

        public void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            table.AddEntity(entity);

        }

        public void CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            foreach (var entity in entities)
            {
                table.AddEntity(entity);
            }

        }

        public void ReplaceRow<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            table.UpdateEntity(entity, ETag.All, TableUpdateMode.Replace);
        }

        public void DeleteRow(string tablename, string partitionKey, string rowKey)
        {
            var table = GetTable(tablename);
            table.DeleteEntity(partitionKey, rowKey);

        }

        public void DeleteRows(string tablename, string partitionKey)
        {
            var table = GetTable(tablename);
            var rows = GetRows<TableEntity>(tablename, partitionKey);
            foreach (var row in rows)
            {
                DeleteRow(tablename, row.PartitionKey, row.RowKey);
            }
        }

        public void DeleteAllRows<T>(string tablename) where T : class, ITableEntity, new()
        {
            var rows = GetRows<T>(tablename);
            foreach (var row in rows)
            {
                DeleteRow(tablename, row.PartitionKey, row.RowKey);
            }
        }

        public IEnumerable<T> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var query = table.Query<T>(x => x.PartitionKey == partitionKey);
            return query.ToList();
        }

        public IEnumerable<T> GetRows<T>(string tablename) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            return table.Query<T>().ToList();
        }

        public T GetRow<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var response = table.GetEntity<T>(partitionKey, rowKey);
            return response.Value;
        }

        public async Task<T> GetRowAsync<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var response = await table.GetEntityAsync<T>(partitionKey, rowKey);
            return response.Value;
        }

        public Response<T> GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            return table.GetEntity<T>(partitionKey, rowKey);
        }

        public TableClient GetTable(string tableName)
        {
            var serviceClient = new TableServiceClient(_storageConnectionString);
            var tableClient = serviceClient.GetTableClient(tableName);
            tableClient.CreateIfNotExists();
            return tableClient;
        }

        public void DeleteTable(string tableName)
        {
            var serviceClient = new TableServiceClient(_storageConnectionString);
            serviceClient.DeleteTable(tableName);
        }

        public void InsertOrReplace<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            table.UpsertEntity(entity, TableUpdateMode.Replace);
        }
    }
}