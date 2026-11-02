namespace Operations.Web.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Web.Repositories;

    [TestClass]
    public class ClosedCollectionRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedCollectionRepository_ShouldReturnFirstPageOfData()
        {
            // arrange
            var now = DateTime.Now;
            const int numRowsInPage = 10;
            ClearAllRows();

            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                InsertRow("APPS", $"APPS{i}", DateTime.Now, 100, 0, now.AddSeconds(i));
            });

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            // act
            var rows = repository.GetClosedCollectionsDesc(0, numRowsInPage).Result;


            // assert
            Assert.AreEqual(numRowsInPage, rows.Count, "The number of rows returned is not right");
            var expectedReturnCodes = Enumerable.Range(2, 10).Select(i => $"APPS{i}");
            Assert.IsTrue(expectedReturnCodes.All(expectedReturnCode => rows.Any(r => r.CollectionReturnCode == expectedReturnCode)), "not all return codes are present" );
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedCollectionRepository_ShouldReturnLastPageOfData()
        {
            // arrange
            var now = DateTime.Now;
            const int numRowsInPage = 10;
            ClearAllRows();

            Enumerable.Range(1, 11).ToList().ForEach(i =>
            {
                InsertRow("APPS", $"APPS{i}", DateTime.Now, 100, 0, now.AddSeconds(i));
            });

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            // act
            var rows = repository.GetClosedCollectionsDesc(1, numRowsInPage).Result;


            // assert
            var expectedReturnCodes = Enumerable.Range(1, 1).Select(i => $"APPS{i}");
            Assert.IsTrue(expectedReturnCodes.All(expectedReturnCode => rows.Any(r => r.CollectionReturnCode == expectedReturnCode)), "not all return codes are present");
        }

        private void ClearAllRows()
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"delete FROM [MonitoringDeliverables].[ClosedCollection]";

                connection.Execute(sql);
            }
        }

        private void InsertRow(string collectionType, string collectionReturnCode, DateTime closedDate, int totalRowCount, int retrievedRows, DateTime createdDate)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection] ( [CollectionType]
                                      ,[CollectionReturnCode]
                                      ,[ClosedTime]
                                      ,[TotalRowCount]
                                      ,[RetrievedRowCount]
                                      ,[CreatedDate]) values (@collectionType, @collectionReturnCode, @closedDate, @totalRowCount, @retrievedRows, @createdDate)";

                connection.Execute(sql, param:new {collectionType, collectionReturnCode, closedDate, totalRowCount, retrievedRows, createdDate});
            }
        }
    }
}
