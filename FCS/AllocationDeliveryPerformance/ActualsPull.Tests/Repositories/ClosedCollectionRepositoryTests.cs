namespace ActualsPull.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using ActualsPull.Repositories;
    using Dapper;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ClosedCollectionRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_ShouldGetLatestClosedDateTime_ReturnsNullWhenThereAreNoRows()
        {
            // arrange
            RemoveAllData();
            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);

            // act
            var latest = repository.GetLatestClosedDateTime(connection, null).Result;

            // assert
            Assert.AreEqual(ClosedCollectionRepository.DefaultDateTime(), latest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_ShouldGetLatestClosedDateTime_ReturnsMostRecent()
        {
            // arrange
            RemoveAllData();
            DateTime now = DateTime.Now;

            InsertClosedCollection("ALLF", "A53", now);
            InsertClosedCollection("ALLF", "A52", now.AddMonths(-1));
            InsertClosedCollection("ALLF", "A51", now.AddMonths(-2));

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);

            // act
            var latest = repository.GetLatestClosedDateTime(connection, null).Result;

            // assert
            Assert.AreEqual(now.ToDateTimeWithoutMilliseconds(), latest.ToDateTimeWithoutMilliseconds());
        }

        private void RemoveAllData()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE 
                    FROM [MonitoringDeliverables].[ClosedCollection]";

                connection.Execute(sql);
            }
        }

        private void InsertClosedCollection(string collectionType, string collectionReturnCode, DateTime closedTime)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection]
                    (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount)
                    values (@collectionType, @collectionReturnCode, @closedTime, 0, 0)";

                connection.Execute(sql, new {collectionType, collectionReturnCode, closedTime});
            }
        }

        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["SqlServerConnectionString"].ConnectionString;
    }
}
