namespace Datafix.Tests.Repositories
{
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;

    public static class AuditMessageRepository
    {
        public static void Add(
            byte[] messageBytes,
            string messageType,
            DateTime sentTime,
            Guid messageId,
            string originatingEndpoint,
            string processingEndpoint,
            string businessKey,
            byte[] propertiesBytes)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            const string sql =
                @"insert into [Operations].[AuditMessage] (MessageId, MessageType, SentTime, OriginatingEndpoint, ProcessingEndpoint, BusinessKey, MessageBytes, PropertiesBytes)
                values (@messageId, @messageType, @sentTime, @originatingEndpoint, @processingEndpoint, @businessKey, @messageBytes, @propertiesBytes);";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(sql, new
                {
                    messageBytes,
                    messageType,
                    sentTime,
                    messageId,
                    originatingEndpoint,
                    processingEndpoint,
                    businessKey,
                    propertiesBytes
                });
            }
        }
    }
}
