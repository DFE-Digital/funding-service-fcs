namespace FCT.Operations.Maintenance.Endpoint.Tests.Repositories
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using System.Linq;

    [TestClass]
    public class ProcessedMessageDeleteRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageDeleteRepository_HousekeepProcessedMessageTable_ShouldRemoveRows()
        {
            // arrange 
            const int noOfDaysForKeepingRecords = 1500;
            var dateForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysForKeepingRecords).Date;

            const int noOfDaysOlderThanNoOfDaysForKeepingRecords = noOfDaysForKeepingRecords + 1;
            var dateOlderThanNoOfDaysForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysOlderThanNoOfDaysForKeepingRecords).Date;

            const string messageIdPrefix = "VeryOldMessageId";

            ClearTestMessageIdRecords(messageIdPrefix);
            CreateTestMessageIdRecords(messageIdPrefix, dateOlderThanNoOfDaysForKeepingRecords);

            var numberOfRecordsToBeRemovedBefore = GetCountOfRecordsToBeRemoved(dateForKeepingRecords);
            Assert.IsTrue(numberOfRecordsToBeRemovedBefore >= 3, "ProcessedMessage test records were not setup correctly within arrange part of the test");

            var repository = new ProcessedMessageDeleteRepository(new LocalConfig());

            // act
            repository.HousekeepProcessedMessageTable("ContractManagement", dateForKeepingRecords).Wait();

            // assert
            var numberOfRecordsToBeRemovedAfter = GetCountOfRecordsToBeRemoved(dateForKeepingRecords);
            Assert.AreEqual(0, numberOfRecordsToBeRemovedAfter, "Not all expected ProcessedMessage records were removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ProcessedMessageDeleteRepository_HousekeepProcessedMessageTable_ShouldNotRemoveRows()
        {
            // arrange 
            const int noOfDaysForKeepingRecords = 1500;
            var dateForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysForKeepingRecords).Date;

            const string messageIdPrefix = "VeryOldMessageId";

            ClearTestMessageIdRecords(messageIdPrefix);
            CreateTestMessageIdRecords(messageIdPrefix, dateForKeepingRecords);

            var countOfRecordsWithMessageIdPrefixBefore = GetCountOfRecordsWithMessageIdPrefix(messageIdPrefix);
            Assert.IsTrue(countOfRecordsWithMessageIdPrefixBefore >= 3, "ProcessedMessage test records were not setup correctly within arrange part of the test");

            var repository = new ProcessedMessageDeleteRepository(new LocalConfig());

            // act
            repository.HousekeepProcessedMessageTable("ContractManagement", dateForKeepingRecords).Wait();

            // assert
            var countOfRecordsWithMessageIdPrefixAfter = GetCountOfRecordsWithMessageIdPrefix(messageIdPrefix);
            Assert.IsTrue(countOfRecordsWithMessageIdPrefixAfter >= 3, "ProcessedMessage test records were incorrectly removed");
        }

        private static void ClearTestMessageIdRecords(string messageIdPrefix)
        {
            const string sql = "delete from ContractManagement.ProcessedMessage where MessageId like @MessageIdPrefix";
            ExecuteSql(sql, new { MessageIdPrefix = messageIdPrefix + "%" });
        }

        private static void CreateTestMessageIdRecords(string messageIdPrefix, DateTime ageOfProcessedMessage)
        {
            const string sql = "insert ContractManagement.ProcessedMessage(MessageId, CreatedDate) values(@messageId, @ageOfProcessedMessage)";
            Enumerable.Range(1, 3).Select(i => $"{messageIdPrefix}{i}").ToList().ForEach(messageId =>
                ExecuteSql(sql, new { messageId, ageOfProcessedMessage }));
        }

        private static int GetCountOfRecordsToBeRemoved(DateTime removeOlderThanDate)
        {
            const string sql = @"select count(*) from ContractManagement.ProcessedMessage where CreatedDate < @removeOlderThanDate";
           return ExecuteScalarSql<int>(sql, new { removeOlderThanDate });
        }

        private static int GetCountOfRecordsWithMessageIdPrefix(string messageIdPrefix)
        {
            const string sql = @"select count(1) from ContractManagement.ProcessedMessage where MessageId like @MessageIdPrefix";
            return ExecuteScalarSql<int>(sql, new { MessageIdPrefix = messageIdPrefix + "%" });
        }

        private static void ExecuteSql(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, parameter);
            }
        }

        private static T ExecuteScalarSql<T>(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.ExecuteScalar<T>(sql, parameter);
            }
        }
    }
}