namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    //using System.Configuration;
    //using System.Threading;
    //using Microsoft.WindowsAzure.Storage;
    //using Microsoft.WindowsAzure.Storage.Table;
    //using Microsoft.WindowsAzure.Storage.Table.Protocol;
    //using Azure.Data.Tables;

    using Azure;
    using Azure.Data.Tables;
    using System;
    using System.Configuration;
    using System.Threading;


    public static class AzureTableStorageHelper
    {
        //private static CloudTable GetTable(string tableName)
        //{
        //    CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
        //    CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
        //    CloudTable table = tableClient.GetTableReference(tableName);

        //    return table;
        //}

        private static TableClient GetTable(string tableName)
        {
            var connectionString =
                ConfigurationManager
                    .ConnectionStrings["StorageConnectionString"]
                    .ConnectionString;

            return new TableClient(connectionString, tableName);
        }


        //private static void SafeCreateIfNotExists(CloudTable table)
        //{
        //    const int retries = 18; // 1x = 10sec. 
        //    StorageException exception = new StorageException();
            
        //    for (int i = 0; i < retries; i++)
        //    {
        //        try
        //        {
        //            table.CreateIfNotExists();
        //            return;
        //        }
        //        catch (StorageException e)
        //        {
        //            exception = e;
        //            if ((e.RequestInformation.HttpStatusCode == 409) && (e.RequestInformation.ExtendedErrorInformation.ErrorCode.Equals(TableErrorCodeStrings.TableBeingDeleted)))
        //                Thread.Sleep(10000);// The table is currently being deleted. Try again until it works.
        //            else
        //                throw;
        //        }
        //    }

        //    //Failed x no of retrys, throw. 
        //    throw exception;
        //}


        private static void SafeCreateIfNotExists(TableClient table)
        {
            try
            {
                const int retries = 18;

                RequestFailedException exception = null;

                for (var i = 0; i < retries; i++)
                {
                    try
                    {
                        table.CreateIfNotExistsAsync()
                             .GetAwaiter()
                             .GetResult();

                        return;
                    }
                    catch (RequestFailedException ex)
                        when (ex.Status == 409 &&
                              string.Equals(
                                  ex.ErrorCode,
                                  "TableBeingDeleted",
                                  StringComparison.OrdinalIgnoreCase))
                    {
                        exception = ex;

                        Thread.Sleep(TimeSpan.FromSeconds(10));
                    }
                }
                //throw (Exception?)exception ?? new InvalidOperationException($"Unable to create table '{table.Name}'.");
            }
            catch (RequestFailedException ex)
            {
             //   throw new InvalidOperationException($"Unable to create table '{table.Name}'.", ex);
            }
        }


        public static void CreateTableIfNotExists(string tableName)
        {
            var table = GetTable(tableName);

            SafeCreateIfNotExists(table);
        }

        public static TableClient GetTableClient(string tableName)
        {
            return GetTable(tableName);
        }


    }
}
