namespace Operations.Web.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;
    using Dapper;
    using System.Data.SqlClient;
    using System;
    using Operations.Web.Repositories;
    using Extensions;

    [TestClass]
    public class MonthEndRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_GetLatestEndTime_ShouldReturnDateTimeWhenThereIsAMonthEndHistoryRecordWithEndTime()
        {            
            // arrange
            var endTime = DateTime.UtcNow.AddHours(-1).ToDateTimeWithoutMilliseconds();

            RemoveAllMonthEndHistoryRecords();
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-10), DateTime.UtcNow.AddHours(-9));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-9), DateTime.UtcNow.AddHours(-8));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-8), DateTime.UtcNow.AddHours(-7));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-7), endTime);

            var monthEndRepository = new MonthEndRepository();

            // act
            var latestEndTime = monthEndRepository.GetLatestEndTime().Result;

            //  assert
            Assert.IsNotNull(latestEndTime, "Incorrectly returned null");
            Assert.AreEqual(endTime, latestEndTime.Value, "Returned latestEndTime is incorrect");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_GetLatestEndTime_ShouldReturnNullWhenThereIsAMonthEndHistoryRecordWithANullEndTime()
        {
            // arrange
            RemoveAllMonthEndHistoryRecords();
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-10), DateTime.UtcNow.AddHours(-9));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-9), DateTime.UtcNow.AddHours(-8));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-8), DateTime.UtcNow.AddHours(-7));
            AddMonthEndHistoryRecord(DateTime.UtcNow.AddHours(-7), null);

            var monthEndRepository = new MonthEndRepository();

            // act
            var latestEndTime = monthEndRepository.GetLatestEndTime().Result;

            //  assert
            Assert.IsNull(latestEndTime, "Did not return null value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void MonthEndRepository_GetLatestEndTime_ShouldReturnNullWhenThereAreNoMonthEndHistoryRecords()
        {
            // arrange
            RemoveAllMonthEndHistoryRecords();

            var monthEndRepository = new MonthEndRepository();

            // act
            var latestEndTime = monthEndRepository.GetLatestEndTime().Result;

            //  assert
            Assert.IsNull(latestEndTime, "Did not return null value");
        }

        private static void AddMonthEndHistoryRecord(DateTime startTime, DateTime? endTime)
        {
            const string sql = @"INSERT INTO [ContractManagement].[MonthEndHistory] 
                                      ([StartTime] ,[EndTime]) 
                                 VALUES  
                                      (@startTime, @endTime)";

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, new { startTime, endTime });
            }
        }

        private static void RemoveAllMonthEndHistoryRecords()
        {
            const string sql = "DELETE FROM [ContractManagement].[MonthEndHistory]";

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql);
            }
        }
    }
}