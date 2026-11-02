namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull
{
    using System;
    using System.Linq;
    using System.Configuration;
    using Endpoint.ActualsPull.Adapters;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common.PagedStorage;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class DcStubAdapterIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DcStubAdapter_GetClosedCollectionsSince_ShouldGetCollectionWhenRepertedActualsAreEmpty()
        {
            // arrange
            var reportedActualGroupStubDataTableName = $"ReportedActualGroupStub{new EnvironmentContext().StorageTableSuffix}";
            var reportedActualTableName = $"ReportedActualStub{new EnvironmentContext().StorageTableSuffix}";
            DeleteRowsFromTable(reportedActualGroupStubDataTableName);
            DeleteRowsFromTable(reportedActualTableName);
            CreateRow(reportedActualGroupStubDataTableName);
            var dcDcStubAdapter = new DcStubAdapter(new AzureTableStore(), new EnvironmentContext());

            // act
            var closedCollections = dcDcStubAdapter.GetClosedCollectionsSince(new DateTime()).Result;

            // assert
            Assert.AreEqual(1, closedCollections.Count);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DcStubAdapter_GetClosedCollectionsSince_ShouldNotDuplicateCollections()
        {
            // arrange
            var reportedActualGroupStubDataTableName = $"ReportedActualGroupStub{new EnvironmentContext().StorageTableSuffix}";
            var reportedActualTableName = $"ReportedActualStub{new EnvironmentContext().StorageTableSuffix}";
            DeleteRowsFromTable(reportedActualGroupStubDataTableName);
            DeleteRowsFromTable(reportedActualTableName);
            CreateRow(reportedActualGroupStubDataTableName);
            CreateRowInReportedActualStub(reportedActualTableName);

            var dcDcStubAdapter = new DcStubAdapter(new AzureTableStore(), new EnvironmentContext());

            // act
            var closedCollections = dcDcStubAdapter.GetClosedCollectionsSince(new DateTime()).Result;

            // assert
            Assert.AreEqual(1, closedCollections.Count);
        }

        private static void CreateRow(string tablename)
        {
            var table = GetTable(tablename);
            table.CreateIfNotExists();
            TableBatchOperation batchOp = new TableBatchOperation();

            batchOp.Add(TableOperation.Insert(new ReportedActualGroup
            {
                PartitionKey = "APPS",
                RowKey = "APPS25",
                RowCount = 0
            }));
            table.ExecuteBatch(batchOp);
        }

        private static void CreateRowInReportedActualStub(string tablename)
        {
            var table = GetTable(tablename);
            table.CreateIfNotExists();
            TableBatchOperation batchOp = new TableBatchOperation();

            batchOp.Add(TableOperation.Insert(new ReportedActual
            {
                PartitionKey = "123",
                RowKey = "456",
                CollectionType = "APPS",
                CollectionReturnCode = "APPS25"
            }));
            table.ExecuteBatch(batchOp);
        }

        private static void DeleteRowsFromTable(string tableName)
        {
            var table = GetTable(tableName);
            table.CreateIfNotExists();

            var query = new TableQuery<ReportedActualGroup>();
            var queryResult = table.ExecuteQuerySegmentedAsync(query, null).Result;

            TableBatchOperation batchDeleteOperation = new TableBatchOperation();

            queryResult.ToList().ForEach(batchDeleteOperation.Delete);

            if (batchDeleteOperation.Any())
            {
                table.ExecuteBatchAsync(batchDeleteOperation).Wait();
            }
        }

        private class ReportedActualGroup : TableEntity
        {
            public int RowCount { get; set; }
        }

        private static CloudTable GetTable(string tablename)
        {
            var storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(tablename);
            return table;
        }
    }
}
