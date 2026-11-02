namespace Datafix.Tests.Tests
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Dapper;
    using Datafix.Tests.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AuditMessageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void AuditMessageRepository_ShouldAdd()
        {
            // arrange
            Guid messageId = Guid.NewGuid();
            const string businessKey = "bk";
            DeleteMessage(businessKey);
            const string messageType = "some type";
            DateTime sentTime = DateTime.UtcNow;
            const string originatingEndpoint = "oe";
            const string processingEndpoint = "pe";
            byte[] messageBytes = new byte[1] {0x1};
            byte[] propertiesBytes = new byte[1] {0x2};

            // act
            AuditMessageRepository.Add(messageBytes, messageType, sentTime, messageId, originatingEndpoint, processingEndpoint, businessKey, propertiesBytes);

            // assert
            var retrievedMessage = GetMessage(messageId);
            Assert.AreEqual(businessKey, retrievedMessage.BusinessKey, "The business key is not set");
            Assert.AreEqual(originatingEndpoint, retrievedMessage.OriginatingEndpoint, "The originatingEndpoint is not set");
            Assert.AreEqual(processingEndpoint, retrievedMessage.ProcessingEndpoint, "The processingEndpoint is not set");
            Assert.AreEqual(messageBytes[0], retrievedMessage.MessageBytes[0], "The messageBytes is not set");
            Assert.AreEqual(propertiesBytes[0], retrievedMessage.PropertiesBytes[0], "The propertiesBytes is not set");
            Assert.AreEqual(RemoveMilliseconds(sentTime), RemoveMilliseconds(retrievedMessage.SentTime), "The sentTime is not set");
            int i = 0;
        }

        private DateTime RemoveMilliseconds(DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute,
                dateTime.Second, DateTimeKind.Utc);
        }

        private void DeleteMessage(string businessKey)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"delete from [Operations].[AuditMessage] where BusinessKey = @businessKey";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, new
                {
                    businessKey
                });
            }
        }

        private dynamic GetMessage(Guid messageId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql = @"select * from [Operations].[AuditMessage] where messageId = @messageId";

            using (var connection = new SqlConnection(connectionString))
            {
                return connection.Query(sql, new
                {
                    messageId
                }).First();
            }
        }
    }
}
