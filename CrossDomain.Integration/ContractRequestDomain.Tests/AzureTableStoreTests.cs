namespace ContractRequestDomain.Tests
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Table;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class AzureTableStoreTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureTableStore_ShouldDeleteAllRowsWhenDeleteAllRowsIsCalled()
        {
            var tablename = "TEST" + Guid.NewGuid().ToString().Replace("-", "");
            string partitionKey1 = Guid.NewGuid().ToString();
            string partitionKey2 = Guid.NewGuid().ToString();

            CreateLotsofRows(tablename, partitionKey1);
            CreateLotsofRows(tablename, partitionKey2);


            IAzureTableStore azureTableStore = new AzureTableStore();
            azureTableStore.DeleteAllRows<TestTableEntity>(tablename);

            var table = GetTable(tablename);
            var query = new TableQuery<TestTableEntity>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey1));
            var queryResultForPk1 = table.ExecuteQuery(query);
            query = new TableQuery<TestTableEntity>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, partitionKey2));
            var queryResultForPk2 = table.ExecuteQuery(query);

            table.Delete();

            Assert.IsTrue(!queryResultForPk1.Any() && !queryResultForPk2.Any(), "There should have been no entries in the table after we call DeleteAllRows");
        }

        public class TestTableEntity : TableEntity
        {
            public string TestEntry { get; set; }        
        }

        private static CloudTable GetTable(string tablename)
        {
            var storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(tablename);
            return table;
        }

        private static void CreateLotsofRows(string tablename, string partitionKey)
        {
            var table = GetTable(tablename);
            table.CreateIfNotExists();

            for (int j = 1; j <= 5; j++)
            {
                TableBatchOperation batchOp = new TableBatchOperation();

                for (int i = 100 * j; i < 100 * (j + 1); i++)
                {
                    TestTableEntity entity = new TestTableEntity
                    {
                        PartitionKey = partitionKey,
                        RowKey = Guid.NewGuid().ToString(),
                        TestEntry = i.ToString()
                    };

                    batchOp.Add(TableOperation.Insert(entity));
                }

                table.ExecuteBatch(batchOp);
            }
        }
    }
}
