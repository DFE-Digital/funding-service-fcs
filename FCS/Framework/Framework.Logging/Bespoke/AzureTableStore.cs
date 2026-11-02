namespace SFA.FCT.Framework.Logging.Bespoke
{
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;

    public static class AzureTableStore
    {
        public static void CreateRow<T>(CloudTable table, T entity) where T : class, ITableEntity, new()
        {
            var insertOperation = TableOperation.Insert(entity);
            table.Execute(insertOperation);
        }

        public static CloudTable GetTable(string tableName, string connectionString)
        {
            var storageAccount = CloudStorageAccount.Parse(connectionString);
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(tableName);
            return table;
        }
    }
}
