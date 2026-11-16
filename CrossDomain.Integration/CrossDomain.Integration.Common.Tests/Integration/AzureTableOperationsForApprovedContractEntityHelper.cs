
namespace CrossDomain.Integration.Common.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Azure;
    using Azure.Data.Tables;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public static class AzureTableOperationsForApprovedContractEntityHelper
    {
       
        public static void InsertPartition(
            string partitionKey,
            int rangeStart,
            int count,
            int pageNumberOnceCommitted,
            StorageObjectSerializer storageObjectSerializer,
            TableClient table) // NEW SDK type
        {
            // Build all entities first
            var entities = Enumerable.Range(rangeStart, count).Select(i =>
            {
                var payload = new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = FormatContractNumber(i),
                            contractVersionNumber = i
                        }
                    }
                };

                return new PagedStorageEntity
                {
                    PartitionKey = partitionKey,
                    RowKey = FormatContractNumberAndContractVersionKeyValue(FormatContractNumber(i), i),
                    PageNumberOnceCommitted = pageNumberOnceCommitted,
                    ContentBytes = storageObjectSerializer.Serialize(payload),
                    // Timestamp/ETag are handled by the service; no need to set here
                };
            }).ToList();

            // Submit in chunks of <= 100 actions (service limit) and single partition
            const int MaxBatchSize = 100;
            for (int skip = 0; skip < entities.Count; skip += MaxBatchSize)
            {
                var batch = entities.Skip(skip).Take(MaxBatchSize)
                    .Select(e => new TableTransactionAction(TableTransactionActionType.Add, e))
                    .ToList();

                // SubmitTransaction is synchronous; use SubmitTransactionAsync in async tests
                table.SubmitTransaction(batch);
            }
        }

        private static string FormatContractNumber(int i) => $"Contract-{i}";

        private static string FormatContractNumberAndContractVersionKeyValue(string contractNumber, int contractVersionNumber)
            => $"{contractNumber.Trim()},{contractVersionNumber}";
    }
}
