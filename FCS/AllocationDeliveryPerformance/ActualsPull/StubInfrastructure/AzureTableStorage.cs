namespace ActualsPull.StubInfrastructure
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public class AzureTableStorage : IAzureTableStore
    {
        private readonly string _storageConnectionString;

        public AzureTableStorage(string storageConnectionString)
        {
            _storageConnectionString = storageConnectionString;
        }

        public async Task<bool> CreateTableIfNotExists(string tableName)
        {
            return await GetTable(tableName).CreateIfNotExistsAsync();
        }

        public async Task<IReadOnlyCollection<T>> GetAllRows<T>(string tablename) where T : class, ITableEntity, new()
        {
            var table = GetTable(tablename);
            TableContinuationToken token = null;
            var entities = new List<T>();
            do
            {
                var queryResult = await table.ExecuteQuerySegmentedAsync(new TableQuery<T>(), token);
                entities.AddRange(queryResult.Results);
                token = queryResult.ContinuationToken;
            } while (token != null);

            return entities;
        }

        public async Task CreateRows<T>(string tablename, IEnumerable<T> entities) where T : class, ITableEntity, new()
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
                        await table.ExecuteBatchAsync(batchInsert);
                        batchInsert = null;
                    }
                }

                if (rowCount > 0 && batchInsert != null)
                {
                    await table.ExecuteBatchAsync(batchInsert);
                }
            }
        }

        public async Task DeleteAllRows(string tablename)
        {
            var allRows = await GetAllRows<TableEntity>(tablename);
            var partitions = allRows.GroupBy(r => r.PartitionKey).ToList();
            var table = GetTable(tablename);

            foreach (var rowsInPartition in partitions)
            {
                TableBatchOperation tableBatchOperation = new TableBatchOperation();
                rowsInPartition.ToList().ForEach(r => tableBatchOperation.Add(TableOperation.Delete(r)));

                await table.ExecuteBatchAsync(tableBatchOperation);
            }
        }

        public async Task DeleteRows(string tablename, string partitionKey)
        {
            TableQuery<TableEntity> deleteQuery = new TableQuery<TableEntity>()
                .Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey)
                )
                .Select(new string[] { "PartitionKey" });

            TableContinuationToken continuationToken = null;
            var table = GetTable(tablename);
            do
            {
                var tableQueryResult = table.ExecuteQuerySegmentedAsync(deleteQuery, continuationToken);

                continuationToken = tableQueryResult.Result.ContinuationToken;

                // Split into chunks of 100 for batching
                List<List<TableEntity>> rowsChunked = tableQueryResult.Result.Select((x, index) => new { Index = index, Value = x })
                    .Where(x => x.Value != null)
                    .GroupBy(x => x.Index / 100)
                    .Select(x => x.Select(v => v.Value).ToList())
                    .ToList();

                // Delete each chunk of 100 in a batch
                foreach (List<TableEntity> rows in rowsChunked)
                {
                    TableBatchOperation tableBatchOperation = new TableBatchOperation();
                    rows.ForEach(x => tableBatchOperation.Add(TableOperation.Delete(x)));

                    await table.ExecuteBatchAsync(tableBatchOperation);
                }
            }
            while (continuationToken != null);
        }

        private CloudTable GetTable(string tableName)
        {
            var storageAccount = CloudStorageAccount.Parse(_storageConnectionString);
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(tableName);
            return table;
        }
    }
}
