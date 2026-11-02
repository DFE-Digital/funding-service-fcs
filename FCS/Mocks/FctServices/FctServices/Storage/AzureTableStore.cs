namespace FctServices.Storage
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Microsoft.WindowsAzure.Storage.Table.Queryable;

    public class AzureTableStore : IAzureTableStore
    {
        public void CreateTable(string tablename)
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

        public TableResult GetResult<T>(string tablename, string partitionKey, string rowKey) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            var retrieveOperation = TableOperation.Retrieve<T>(partitionKey, rowKey);
            return table.Execute(retrieveOperation);
        }

        public CloudTable GetTable(string tableName)
        {
            var storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
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