namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using Endpoint.ActualsPull.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using Tests.Extensions;

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

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_ShouldCreateClosedCollection()
        {
            // arrange
            RemoveAllData();

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);
            const string collectionType = "CT1";
            const string collectionReturnCode = "CRC1";
            const int totalRows = 10;
            DateTime now = DateTime.UtcNow;

            ClosedCollection closedCollection = new ClosedCollection(collectionType:collectionType,
                collectionReturnCode:collectionReturnCode,
                closedTime:now,
                totalRowCount:totalRows);
            // act
            repository.CreateClosedCollection(connection, null, closedCollection).Wait();

            // assert
            var retrieved = GetClosedCollection(collectionType, collectionReturnCode);
            Assert.AreEqual(totalRows, retrieved.TotalRowCount, "The total number of rows is incorrect");
            Assert.AreEqual(now.ToDateTimeWithoutMilliseconds(), retrieved.ClosedTime.ToDateTimeWithoutMilliseconds(), "The ClosedTime is incorrect");
            Assert.IsNull(retrieved.RetrievedRowCount, "RetrievedRowCount was not null");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_UpdateRowToCompleted_ShouldReturnZeroIfNoUpdateTakesPlace()
        {
            // arrange
            RemoveAllData();

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);
            const string collectionType = "CT1";
            const string collectionReturnCode = "CRC1";

            InsertClosedCollection(collectionType, collectionReturnCode, rowsRetrieved: 10);

            // act
            var rowsUpdated = repository.UpdateRowToCompletedIfNoOneElseHas(
                connection,
                null,
                collectionType,
                collectionReturnCode,
                10).Result;

            // assert
            Assert.AreEqual(0, rowsUpdated, "The rows updated is not incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_UpdateRowToCompleted_ShouldReturnOneIfUpdateTakesPlace()
        {
            // arrange
            RemoveAllData();

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);
            const string collectionType = "CT1";
            const string collectionReturnCode = "CRC1";

            // Will result in RetrievedRowCount been null
            InsertClosedCollection(collectionType, collectionReturnCode, closedTime: DateTime.Now);

            // act
            var rowsUpdated = repository.UpdateRowToCompletedIfNoOneElseHas(
                connection,
                null,
                collectionType,
                collectionReturnCode,
                10).Result;

            // assert
            Assert.AreEqual(1, rowsUpdated, "The rows updated is not incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ClosedConnectionRepository_Get_ShouldReturnOne()
        {
            // arrange
            RemoveAllData();

            ClosedCollectionRepository repository = new ClosedCollectionRepository();
            SqlConnection connection = new SqlConnection(ConnectionString);
            const string collectionType = "CT1";
            const string collectionReturnCode = "CRC1";

            InsertClosedCollection(collectionType, collectionReturnCode, 0);

            // act
            var rowRetrieved = repository.Get(connection,
                null,
                collectionType,
                collectionReturnCode).Result;

            // assert
            Assert.IsNotNull(rowRetrieved);
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
                    (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount)
                    values (@collectionType, @collectionReturnCode, @closedTime, 0)";

                connection.Execute(sql, new { collectionType, collectionReturnCode, closedTime });
            }
        }

        private void InsertClosedCollection(string collectionType, string collectionReturnCode, int rowsRetrieved)
        {
            DateTime closedTime = DateTime.UtcNow;
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"insert into [MonitoringDeliverables].[ClosedCollection]
                    (CollectionType, CollectionReturnCode, ClosedTime, TotalRowCount, RetrievedRowCount)
                    values (@collectionType, @collectionReturnCode, @closedTime, 0, @rowsRetrieved)";

                connection.Execute(sql, new { collectionType, collectionReturnCode, closedTime, rowsRetrieved});
            }
        }

        private ClosedCollection GetClosedCollection(string collectionType, string collectionReturnCode)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"select * from [MonitoringDeliverables].[ClosedCollection]
                    where CollectionType = @collectionType
                    and CollectionReturnCode = @collectionReturnCode";

                return connection.QuerySingle<ClosedCollection>(sql, new { collectionType, collectionReturnCode});
            }
        }

        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;
    }
}
