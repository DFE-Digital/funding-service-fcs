namespace ActualsPull.Tests.StubInfrastructure
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using ActualsPull.StubInfrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AzureTableStorageTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AzureTableStorage_ShouldGetRows()
        {
            // arrange
            var connectionString = ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString;
            var suffix = ConfigurationManager.AppSettings["StorageTableSuffix"];
            string tableName = $"ReportedActual{suffix}";
            string partitionKey = "T1_";

            AzureTableStorage azureTableStorage = new AzureTableStorage(connectionString);
            azureTableStorage.CreateTableIfNotExists(tableName).Wait();
            azureTableStorage.DeleteAllRows(tableName).Wait();
            List <ReportedActual> actuals = new List<ReportedActual>
            {
                new ReportedActual
                {
                    CollectionType = "T1",
                    ContractAllocationNumber = "A1"
                },
                new ReportedActual
                {
                    CollectionType = "T1",
                    ContractAllocationNumber = "A2"
                }
            };

            actuals.ForEach(e =>
            {
                e.RowKey = e.EntityRowKey;
                e.PartitionKey = e.EntityPartitionKey;
            });

            azureTableStorage.CreateRows(tableName, actuals).Wait();

            // act
            var rows = azureTableStorage.GetAllRows<ReportedActual>(tableName).Result;

            // assert
            Assert.AreEqual(2, rows.Count());
        }
    }
}
