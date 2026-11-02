namespace FundingStreamConfigDomain.Web.Tests.Helpers
{
    using System;
 
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    public static class StorageHelper
    {
        public static void CleardownStorage<T>(
                 string latestPagePartitionKey,
                 Func<string, string> formatCorrelationTableNameFunc,
                 string correlationPartitionKey,
                 IPagedStorageRepository<T> repository,
                 IAzureTableStore azureTableStore
            )   
        {
            var latestRows = azureTableStore.GetRows<PagedStorageEntity>(repository.TableName, latestPagePartitionKey).ToList();

            if (latestRows.Any())
            {
                azureTableStore.DeleteRows(repository.TableName, latestPagePartitionKey);

                for (var partitionKey = latestRows.First().PageNumberOnceCommitted - 1; partitionKey > 0; partitionKey--)
                {
                    azureTableStore.DeleteRows(repository.TableName, partitionKey.ToString());
                }
            }

            azureTableStore.DeleteRows(formatCorrelationTableNameFunc(repository.TableName), correlationPartitionKey);
        }
    }
}
