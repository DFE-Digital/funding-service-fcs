namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System.Configuration;
    using System.Threading;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using Microsoft.WindowsAzure.Storage.Table.Protocol;

    public static class AzureTableStorageHelper
    {
        private static CloudTable GetTable(string tableName)
        {
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
            CloudTable table = tableClient.GetTableReference(tableName);

            return table;
        }

        private static void SafeCreateIfNotExists(CloudTable table)
        {
            const int retries = 18; // 1x = 10sec. 
            StorageException exception = new StorageException();
            
            for (int i = 0; i < retries; i++)
            {
                try
                {
                    table.CreateIfNotExists();
                    return;
                }
                catch (StorageException e)
                {
                    exception = e;
                    if ((e.RequestInformation.HttpStatusCode == 409) && (e.RequestInformation.ExtendedErrorInformation.ErrorCode.Equals(TableErrorCodeStrings.TableBeingDeleted)))
                        Thread.Sleep(10000);// The table is currently being deleted. Try again until it works.
                    else
                        throw;
                }
            }

            //Failed x no of retrys, throw. 
            throw exception;
        }
    }
}
