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
    public class AuditMessageDeleteRepositoryTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["OperationsDbContext"].ConnectionString;

        [TestMethod, TestCategory("IntegrationTest")]
        public void AuditMessageDeleteRepository_HousekeepAuditMessageTable_ShouldRemoveRows()
        {
            // arrange 
            const int noOfDaysForKeepingRecords = 1500;
            var dateForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysForKeepingRecords).Date;

            const int noOfDaysOlderThanNoOfDaysForKeepingRecords = noOfDaysForKeepingRecords + 1;
            var dateOlderThanNoOfDaysForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysOlderThanNoOfDaysForKeepingRecords).Date;

            const string businessKeyPrefix = "BusinessKey";

            ClearAuditMessageIdRecords(businessKeyPrefix);
            CreateAuditMessageIdRecords(businessKeyPrefix, dateOlderThanNoOfDaysForKeepingRecords);

            var numberOfRecordsToBeRemovedBefore = GetCountOfRecordsToBeRemoved(dateForKeepingRecords);
            Assert.IsTrue(numberOfRecordsToBeRemovedBefore >= 3, "AuditMessage test records were not setup correctly within arrange part of the test");

            var repository = new AuditMessageDeleteRepository(new LocalConfig());

            // act
            repository.HousekeepAuditMessageTable(dateForKeepingRecords).Wait();

            // assert
            var numberOfRecordsToBeRemovedAfter = GetCountOfRecordsToBeRemoved(dateForKeepingRecords);
            Assert.AreEqual(0, numberOfRecordsToBeRemovedAfter, "Not all expected AuditMessage records were removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AuditMessageDeleteRepository_HousekeepAuditMessageTable__ShouldNotRemoveRowsNewerThanDateForKeepingRecords()
        {
            // arrange 
            const int noOfDaysForKeepingRecords = 1500;
            var dateForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysForKeepingRecords).Date;

            const int noOfDaysNewerThanNoOfDaysForKeepingRecords = noOfDaysForKeepingRecords - 1;
            var dateNewerThanNoOfDaysForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysNewerThanNoOfDaysForKeepingRecords).Date;

            const string businessKeyPrefix = "BusinessKey";

            ClearAuditMessageIdRecords(businessKeyPrefix);
            CreateAuditMessageIdRecords(businessKeyPrefix, dateNewerThanNoOfDaysForKeepingRecords);

            var numberOfAssertRecordsBefore = GetCountOfAssertRecords(businessKeyPrefix);
            Assert.IsTrue(numberOfAssertRecordsBefore >= 3, "AuditMessage test records were not setup correctly within arrange part of the test");

            var repository = new AuditMessageDeleteRepository(new LocalConfig());

            // act
            repository.HousekeepAuditMessageTable(dateForKeepingRecords).Wait();

            // assert
            var numberOfAssertRecordsAfter = GetCountOfAssertRecords(businessKeyPrefix);
            Assert.IsTrue(numberOfAssertRecordsAfter >= 3, "Some AuditMessage records were incorrectly removed");
            ClearAuditMessageIdRecords(businessKeyPrefix);
        }

        private static void ClearAuditMessageIdRecords(string businessKeyPrefix)
        {
            const string sql = "delete from Operations.AuditMessage where BusinessKey like @businessKeyPrefix";
            ExecuteSql(sql, new { businessKeyPrefix = businessKeyPrefix + "%" });
        }

        private static void CreateAuditMessageIdRecords(string businessKeyPrefix, DateTime ageOfAuditMessage)
        {
            const string sql = "INSERT INTO Operations.AuditMessage(MessageId, MessageType, SentTime, OriginatingEndpoint, ProcessingEndpoint, " +
                               "BusinessKey, MessageBytes, PropertiesBytes, CreatedDate) " +
                               "VALUES (newid(), 'MessageType', getutcdate(), 'OriginatingEndpoint', 'ProcessingEndpoint', @businessKey, " +
                               "CAST('MessageBytes' AS VARBINARY(MAX)), CAST('PropertiesBytes' AS VARBINARY(MAX)), @ageOfAuditMessage)";

            Enumerable.Range(1, 3).Select(i => $"{businessKeyPrefix}{i}").ToList().ForEach(businessKey =>
                ExecuteSql(sql, new { businessKey, ageOfAuditMessage }));
        }

        private static int GetCountOfRecordsToBeRemoved(DateTime removeOlderThanDate)
        {
            const string sql = @"select count(*) from Operations.AuditMessage where CreatedDate < @removeOlderThanDate";
            return ExecuteScalarSql<int>(sql, new { removeOlderThanDate });
        }

        private static int GetCountOfAssertRecords(string businessKeyPrefix)
        {
            const string sql = @"select count(*) from Operations.AuditMessage where BusinessKey like @businessKeyPrefix";
            return ExecuteScalarSql<int>(sql, new { businessKeyPrefix = businessKeyPrefix + "%" });
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