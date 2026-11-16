
namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using Endpoint.ActualsPull.Adapters;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using System;
    using System.Configuration;
    using System.Linq;

    [TestClass]
    public class DcStubAdapterIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DcStubAdapter_GetClosedCollectionsSince_ShouldGetCollectionWhenRepertedActualsAreEmpty()
        {
            // arrange
            var suffix = new EnvironmentContext().StorageTableSuffix;
            var groupTable = $"ReportedActualGroupStub{suffix}";
            var actualTable = $"ReportedActualStub{suffix}";

            DeleteRowsFromTable(groupTable);
            DeleteRowsFromTable(actualTable);

            CreateRow(groupTable);

            var adapter = new DcStubAdapter(new AzureTableStore(), new EnvironmentContext());

            // act
            var result = adapter.GetClosedCollectionsSince(new DateTime()).Result;

            // assert
            Assert.AreEqual(1, result.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DcStubAdapter_GetClosedCollectionsSince_ShouldNotDuplicateCollections()
        {
            var suffix = new EnvironmentContext().StorageTableSuffix;
            var groupTable = $"ReportedActualGroupStub{suffix}";
            var actualTable = $"ReportedActualStub{suffix}";

            DeleteRowsFromTable(groupTable);
            DeleteRowsFromTable(actualTable);

            CreateRow(groupTable);
            CreateRowInReportedActualStub(actualTable);

            var adapter = new DcStubAdapter(new AzureTableStore(), new EnvironmentContext());

            var result = adapter.GetClosedCollectionsSince(new DateTime()).Result;

            Assert.AreEqual(1, result.Count);
        }

        // ✅ FIXED

        private static void CreateRow(string tableName)
        {
            var table = GetTable(tableName);

            table.CreateIfNotExistsAsync().GetAwaiter().GetResult();

            var batch = new TableBatchOperation();

            batch.Add(TableOperation.Insert(new ReportedActualGroup
            {
                PartitionKey = "APPS",
                RowKey = "APPS25",
                RowCount = 0
            }));

            table.ExecuteBatchAsync(batch).GetAwaiter().GetResult();
        }


        // ✅ FIXED (uses wrapper entity)

        private static void CreateRowInReportedActualStub(string tableName)
        {
            var table = GetTable(tableName);

            table.CreateIfNotExistsAsync().GetAwaiter().GetResult();

            var batch = new TableBatchOperation();

            batch.Add(TableOperation.Insert(new ReportedActualTableEntity
            {
                PartitionKey = "123",
                RowKey = "456",
                CollectionType = "APPS",
                CollectionReturnCode = "APPS25"
            }));

            table.ExecuteBatchAsync(batch).GetAwaiter().GetResult();
        }


        private static void DeleteRowsFromTable(string tableName)
        {
            var table = GetTable(tableName);

            table.CreateIfNotExistsAsync().GetAwaiter().GetResult();

            var query = new TableQuery<ReportedActualGroup>();
            var result = table.ExecuteQuerySegmentedAsync(query, null).Result;

            var batch = new TableBatchOperation();

            result.Results.ForEach(e => batch.Delete(e));

            if (batch.Any())
            {
                table.ExecuteBatchAsync(batch).GetAwaiter().GetResult();
            }
        }


        // ✅ TEST ENTITY (existing)
        private class ReportedActualGroup : TableEntity
        {
            public int RowCount { get; set; }
        }

        // ✅ ✅ ✅ IMPORTANT FIX – wrapper entity
        private class ReportedActualTableEntity : TableEntity
        {
            public string CollectionType { get; set; }
            public string CollectionReturnCode { get; set; }
        }

        private static CloudTable GetTable(string tableName)
        {
            var connectionString = ConfigurationManager
                .ConnectionStrings["StorageConnectionString"]
                .ConnectionString;

            var account = CloudStorageAccount.Parse(connectionString);
            var client = account.CreateCloudTableClient();
            return client.GetTableReference(tableName);
        }
    }
}
