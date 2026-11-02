namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using CrossDomain.Integration.Common.Storage;

    public class AzureStorageRetryUtils
    {
        private readonly AzureTableStore _azureTableStore;

        public AzureStorageRetryUtils(AzureTableStore azureTableStore)
        {
            _azureTableStore = azureTableStore;
        }

        public void DeleteRowFromAzureTableWithRetries(string tableName, string partitionKey)
        {
            ActionRetrier.RetryWhenExceptionThrown(() =>
            {
                _azureTableStore.DeleteRows(tableName, partitionKey);
            });
        }
    }
}
