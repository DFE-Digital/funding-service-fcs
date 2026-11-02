namespace AllocationDeliveryDomain.Endpoint.Tests.ActualsPull.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Endpoint.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class MonthEndHistoryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndHistoryRepository_CreateNewMonthEndEntry_ShouldCreateNewRow()
        {
            // arrange
            RemoveAllData();
            MonthEndHistoryRepository repository = new MonthEndHistoryRepository();
            
            // act
            repository.CreateNewMonthEndEntry(new SqlConnection(ConnectionString), null).Wait();

            // assert
            var monthEnds = GetMonthEndHistories();
            Assert.AreEqual(1, monthEnds.Count, "The wrong number of month end rows have been created");
            Assert.AreEqual(null, monthEnds.Single().EndTime, "The EndTime should be null");
        }

        private void RemoveAllData()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"DELETE 
                    FROM [ContractManagement].[MonthEndHistory]";

                connection.Execute(sql);
            }
        }

        private IReadOnlyCollection<MonthEndHistory> GetMonthEndHistories()
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                const string sql = @"select * from [ContractManagement].[MonthEndHistory]";

                return connection.Query<MonthEndHistory>(sql).ToList();
            }
        }

        private string ConnectionString =>
            ConfigurationManager.ConnectionStrings["MonitoringDeliverablesDbContext"].ConnectionString;

        private class MonthEndHistory
        {
            public int Id { get; set; }

            public DateTime StartTime { get; set; }

            public DateTime? EndTime { get; set; }
        }
    }
}
