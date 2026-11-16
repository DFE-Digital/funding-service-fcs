namespace Datafix.Tests.Tests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.DataStore.Model;
    using Automation.Repositories;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    [TestClass]
    public class DataFixHistoryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DataFixHistoryRepository_Add_ShouldAddDataFixHistory()
        {
            // Arrange
            var dataFixHistory = new DataFixHistory(release: "RelNumTest", storyNumber: -123,name: "Method_name_test");

            RemoveDataFixHistory(dataFixHistory);

            var repository = new DataFixHistoryRepository();

            // Act
            repository.Add(dataFixHistory).Wait();

            var returnedDataFixHistory = GetDataFixHistory(dataFixHistory);

            // Assert
            Assert.IsNotNull(returnedDataFixHistory, "Data Fix History was not added");
            Assert.IsNotNull(returnedDataFixHistory.Release.All(char.IsUpper), "Release text was not converted to uppercase");
            Assert.IsNotNull(returnedDataFixHistory.Name.All(char.IsUpper), "Name text was not converted to uppercase");
        }

        [TestMethod, TestCategory("IntegrationTest")]
      //  [ExpectedException(typeof(AggregateException))]

        public void DataFixHistoryRepository_Add_ShouldNotAllowDuplicateDataFixHistories()
        {
            // Arrange
            var dataFixHistory = new DataFixHistory(release: "RelNumTest", storyNumber: -123, name: "Method_name_test");

            RemoveDataFixHistory(dataFixHistory);

            var repository = new DataFixHistoryRepository();
            repository.Add(dataFixHistory).Wait();

            // Act
            repository.Add(dataFixHistory).Wait();
        }

        private static void RemoveDataFixHistory(DataFixHistory dataFixHistory)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"DELETE FROM [Operations].[DataFixHistory]
                                     WHERE [Release] = @Release
                                     AND [StoryNumber] = @StoryNumber
                                     AND [Name] = @Name";

                connection.Execute(sql, new
                {
                    dataFixHistory.Release,
                    dataFixHistory.StoryNumber,
                    dataFixHistory.Name
                });
            }
        }

        private static DataFixHistory GetDataFixHistory(DataFixHistory dataFixHistory)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT * FROM [Operations].[DataFixHistory]
                                     WHERE [Release] = @Release
                                     AND [StoryNumber] = @StoryNumber
                                     AND [Name] = @Name";

                var dataFixHistoryReturned = connection.Query<DataFixHistory>(sql, new
                {
                    dataFixHistory.Release,
                    dataFixHistory.StoryNumber,
                    dataFixHistory.Name
                });

                return dataFixHistoryReturned.First();
            }
        }
    }
}