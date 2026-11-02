namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public static class AzureTableOperationsForApprovedContractEntityHelper
    {
        public static void InsertPartition(string partitionKey, int rangeStart, int count, int pageNumberOnceCommitted, StorageObjectSerializer storageObjectSerializer, CloudTable table)
        {
            var batchOperation = new TableBatchOperation();

            Enumerable.Range(rangeStart, count).ToList().ForEach(i => batchOperation.Add(TableOperation.Insert(new PagedStorageEntity
            {
                PartitionKey = partitionKey,
                RowKey = FormatContractNumberAndContractVersionKeyValue(FormatContractNumber(i), i),
                PageNumberOnceCommitted = pageNumberOnceCommitted,
                ContentBytes = storageObjectSerializer.Serialize(new contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = FormatContractNumber(i),
                            contractVersionNumber = i
                        }
                    }
                })
            })));

            table.ExecuteBatch(batchOperation);
        }

        private static string FormatContractNumber(int i)
        {
            return string.Format("Contract-{0}", i);
        }

        private static string FormatContractNumberAndContractVersionKeyValue(string contractNumber, int contractVersionNumber)
        {
            return string.Format("{0},{1}", contractNumber.Trim(), contractVersionNumber);
        }
    }
}
