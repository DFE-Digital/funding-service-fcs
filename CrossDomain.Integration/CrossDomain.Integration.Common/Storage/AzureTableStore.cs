namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Microsoft.WindowsAzure.Storage.Table.Queryable;
    using MoreLinq;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;

    public class AzureTableStore : IAzureTableStore
    {
        private readonly string _storageConnectionString;


        public AzureTableStore()
            : this(GetStorageConnectionString())
        {
        }

        private static string GetStorageConnectionString()
        {
            var cs = ConfigurationManager.ConnectionStrings["StorageConnectionString"]?.ConnectionString;

            if (!string.IsNullOrWhiteSpace(cs))
                return cs;

            // fallback to AppSettings (since you already populate it)
            cs = ConfigurationManager.AppSettings["AzureStorage:ConnectionString"];

            if (!string.IsNullOrWhiteSpace(cs))
                return cs;

            throw new InvalidOperationException("Storage connection string is not configured.");
        }


        public AzureTableStore(string storageConnectionString)
        {
            _storageConnectionString = storageConnectionString;
        }

        public void CreateTableIfNotExists(string tablename)
        {
            GetTable(tablename).CreateIfNotExists();
        }

        public void CreateRow<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var insertOperation = TableOperation.Insert(entity);
            table.Execute(insertOperation);
        }

        public void CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var groupedByPartitionKey = entities.GroupBy(e => e.PartitionKey);

            foreach (var group in groupedByPartitionKey)
            {
                var rowCount = 0;
                TableBatchOperation batchInsert = null;
                foreach (var row in group)
                {
                    if (batchInsert == null)
                    {
                        batchInsert = new TableBatchOperation();
                        rowCount = 0;
                    }

                    batchInsert.Add(TableOperation.Insert(row));
                    rowCount++;

                    if (rowCount == 100)
                    {
                        table.ExecuteBatch(batchInsert);
                        batchInsert = null;
                    }
                }

                if (rowCount > 0 && batchInsert != null)
                {
                    table.ExecuteBatch(batchInsert);
                }
            }
        }

        public void ReplaceRow<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var updateOperation = TableOperation.Replace(entity);
            table.Execute(updateOperation);
        }

        public void DeleteRow(string tablename, string partitionKey, string rowKey)
        {
            var table = GetTable(tablename);
            var deleteOperation = TableOperation.Delete(new TableEntity { PartitionKey = partitionKey, RowKey = rowKey, ETag = "*" });
            table.Execute(deleteOperation);
        }

        public void DeleteRows(string tablename, string partitionKey)
        {
            var table = GetTable(tablename);
            var query = new TableQuery().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey));
            var rowsToDelete = table.ExecuteQuery(query);

            TableBatchOperation batchDelete = null;

            foreach (var row in rowsToDelete)
            {
                if (batchDelete == null)
                {
                    batchDelete = new TableBatchOperation();
                }

                var deleteAction = TableOperation.Delete(row);
                batchDelete.Add(deleteAction);

                if (batchDelete.Count == 100)
                {
                    table.ExecuteBatch(batchDelete);
                    batchDelete = null;
                }
            }

            if (batchDelete != null)
            {
                table.ExecuteBatch(batchDelete);
            }
        }

        public void DeleteAllRows<T>(string tablename) where T : class, ITableEntity, new()
        {
            CreateTableIfNotExists(tablename);
            var allRows = GetRows<T>(tablename);
            var distinctPartitionKeys = allRows.Select(row => row.PartitionKey).Distinct();

            distinctPartitionKeys.ForEach(pk => DeleteRows(tablename, pk));
        }

        public IEnumerable<T> GetRows<T>(string tablename, string partitionKey) where T : class, ITableEntity, new()
        {
            var result = new List<T>();
            var table = GetTable(tablename);
            var tableQuery = table.CreateQuery<T>().AsTableQuery();
            TableContinuationToken continuationToken = null;

            if (!string.IsNullOrWhiteSpace(partitionKey))
            {
                tableQuery = tableQuery.Where(x => x.PartitionKey == partitionKey).AsTableQuery();
            }

            do
            {
                var queryResult = tableQuery.ExecuteSegmented(continuationToken);
                result.AddRange(queryResult.ToList());
                continuationToken = queryResult.ContinuationToken;
            }
            while (continuationToken != null);

            return result;
        }

        public IEnumerable<T> GetRows<T>(string tablename) where T : class, ITableEntity, new()
        {
            return GetRows<T>(tablename, null);
        }

        public T GetRow<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var retrieveOperation = TableOperation.Retrieve<T>(partitionKey, rowKey);
            return table.Execute(retrieveOperation).Result as T;
        }

        public async Task<T> GetRowAsync<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var retrieveOperation = TableOperation.Retrieve<T>(partitionKey, rowKey);
            TableResult tableResult = await table.ExecuteAsync(retrieveOperation);
            return tableResult.Result as T;
        }

        public TableResult GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var retrieveOperation = TableOperation.Retrieve<T>(partitionKey, rowKey);
            return table.Execute(retrieveOperation);
        }

        public CloudTable GetTable(string tableName)
        {
            var storageAccount = CloudStorageAccount.Parse(_storageConnectionString);
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(tableName);
            return table;
        }

        public void DeleteTable(string tableName)
        {
            var table = GetTable(tableName);
            table.Delete();
        }

        public void InsertOrReplace<T>(string tablename, T entity) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var updateOperation = TableOperation.InsertOrReplace(entity);
            table.Execute(updateOperation);
        }
    }
}