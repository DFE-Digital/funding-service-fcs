namespace FundingAllocation
{
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.Framework.Logging.Bespoke;

    public  class AzureStorageTable
    {
        public static void CreateRowInAzure(LogEntry logEntry, string connectionString)
        {
            var cloudTable = GetCloudTable(connectionString);

            var insertOperation = TableOperation.Insert(logEntry);
            cloudTable.ExecuteAsync(insertOperation).Wait();
        }

        private static CloudTable GetCloudTable(string azureStorageConnectionString)
        {
            var azureTable = AzureTableStore.GetTable(
                tableName: "WADLogsTable",
                connectionString: azureStorageConnectionString);

            return azureTable;
        }
    }
}