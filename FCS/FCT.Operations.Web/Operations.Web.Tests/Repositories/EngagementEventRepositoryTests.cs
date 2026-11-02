namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using Dapper;
    using System.Data.SqlClient;
    using System.Linq;

    [TestClass]
    public class EngagementEventRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_Add_ShouldAddEngagementEventAndReturnEventId()
        {
            // Arrange
            const string providerId = "123456781";

            RemoveEngagementEvent(providerId);

            var repository = new Web.Repositories.EngagementEventRepository();

            // Act
            var result = repository.AddIfNotAlreadyAdded(providerId).Result;

            // Assert 
            Assert.IsTrue(result.IsAdded, "The provider has not been added");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_Add_ShouldOnlyAddEngagementEventWhenOneIsNotRecentlyThere()
        {
            // Arrange
            const string providerId = "123456781";

            RemoveEngagementEvent(providerId);

            var repository = new Web.Repositories.EngagementEventRepository();
            repository.AddIfNotAlreadyAdded(providerId).Wait();

            // Act
            var result = repository.AddIfNotAlreadyAdded(providerId).Result;

            // Assert 
            Assert.IsFalse(result.IsAdded, "The provider has been added");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void EngagementEventRepository_GetRecentEngagementEvents_ShouldReturnEngagementEvents()
        {
            // Arrange
            ClearEngagementEventTable();
            Enumerable.Range(1,40).ToList().ForEach(i =>
            {
                InsertRow(i, 10000000 + i);
            });

            var repository = new Web.Repositories.EngagementEventRepository();

            // Act
            var recentEngagementEventInfos = repository.GetRecentEngagementEvents().Result;

            // Assert 
            Assert.AreEqual(30, recentEngagementEventInfos.Count, "Incorrect number of rows returned");
            Assert.AreEqual("ProviderNotFound", recentEngagementEventInfos.First().ProcessingState, "Enum was not converted to its name");
        }

        public void RemoveEngagementEvent(string providerId)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE FROM [ContractManagement].[EngagementEvent] WHERE [ProviderId] = @providerId";

                connection.Execute(sql, new { providerId });
            }
        }

        public void ClearEngagementEventTable()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE FROM [ContractManagement].[EngagementEvent]";

                connection.Execute(sql);
            }
        }

        private static void InsertRow(int eventId, int providerId)
        {
            var connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"INSERT INTO [ContractManagement].[EngagementEvent] ([EventId]
                                       ,[EventType]
                                       ,[ProviderId]
                                       ,[ProcessingState]) values (@eventId, 'INITIATED', @providerId, 5);";

                connection.Execute(sql, param: new {eventId, providerId});
            }
        }
    }
}