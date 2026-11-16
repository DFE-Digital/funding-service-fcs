
namespace ContractRequestDomain.Tests
{
    extern alias CSICommon;
    // Modern Azure Tables SDK
    using Azure;
    using Azure.Data.Tables;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using CSICommon::SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Bespoke;
    using System;
    using System.Configuration;
    using System.Linq;

    [TestClass]
    public class AzureTableStoreTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureTableStore_ShouldDeleteAllRowsWhenDeleteAllRowsIsCalled()
        {
            var tablename = "TEST" + Guid.NewGuid().ToString("N");
            string partitionKey1 = Guid.NewGuid().ToString();
            string partitionKey2 = Guid.NewGuid().ToString();

            // seed two partitions
            CreateLotsofRows(tablename, partitionKey1);
            CreateLotsofRows(tablename, partitionKey2);

            // Use your existing abstraction (leave as-is)
            // If you see a “type exists in both assemblies” error for AzureTableStore,
            // remove the duplicate reference or fully-qualify the intended type.
            IAzureTableStore azureTableStore = new CSICommon::SFA.FCT.CrossDomain.Integration.Common.Storage.AzureTableStore();
            azureTableStore.DeleteAllRows<TestTableEntity>(tablename);

            // query after delete
            var table = GetTable(tablename);

            var queryResultForPk1 = table
                .Query<TestTableEntity>(filter: $"PartitionKey eq '{partitionKey1}'")
                .ToList(); // Pageable<T> -> list  (modern Query API)  [4](https://docs.particular.net/nservicebus/testing/)

            var queryResultForPk2 = table
                .Query<TestTableEntity>(filter: $"PartitionKey eq '{partitionKey2}'")
                .ToList();

            // drop table
            var conn = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            var service = new TableServiceClient(conn);
            service.DeleteTable(tablename);

            Assert.IsTrue(!queryResultForPk1.Any() && !queryResultForPk2.Any(),
                "There should have been no entries in the table after we call DeleteAllRows");
        }

        // NOTE: Name preserved (type updated to modern ITableEntity)
        public class TestTableEntity : ITableEntity
        {
            public string PartitionKey { get; set; } = default!;
            public string RowKey { get; set; } = default!;
            public DateTimeOffset? Timestamp { get; set; }
            public ETag ETag { get; set; }
            public string TestEntry { get; set; } = string.Empty;
        }

        // NOTE: Function name preserved (return type updated to TableClient)
        private static TableClient GetTable(string tablename)
        {
            var conn = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            var service = new TableServiceClient(conn);
            return service.GetTableClient(tablename);
        }

        // NOTE: Function name preserved (implementation updated for modern SDK)
        private static void CreateLotsofRows(string tablename, string partitionKey)
        {
            var conn = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            var service = new TableServiceClient(conn);
            var table = service.GetTableClient(tablename);

            // Create the table if it does not exist (modern API)
            table.CreateIfNotExists(); // [1](https://github.com/ShirasHassan/NServiceBusV5/blob/main/transports/azure-service-bus/legacy/configuration/full.md)

            // Insert 5 batches, each ~100 entities (batch limit is 100; same PartitionKey per batch)
            for (int j = 1; j <= 5; j++)
            {
                var actions = new System.Collections.Generic.List<TableTransactionAction>(capacity: 100);

                for (int i = 100 * j; i < 100 * (j + 1); i++)
                {
                    var entity = new TestTableEntity
                    {
                        PartitionKey = partitionKey,
                        RowKey = Guid.NewGuid().ToString("N"),
                        TestEntry = i.ToString()
                    };

                    actions.Add(new TableTransactionAction(TableTransactionActionType.Add, entity));
                }

                // Submit transactional batch
                table.SubmitTransaction(actions); // [2](https://github.com/Azure/azure-sdk-for-net/issues/48745)
            }
        }
    }
}
