namespace Operations.DataStore.Repositories
{
    using System.Data;
    using System.Threading.Tasks;
    using Dapper;
    using Model;

    public static class AuditMessageRepository
    {
        public static async Task Add(AuditMessage auditMessage, IDbConnection connection)
        {
            const string sql = @"
                INSERT INTO [Operations].[AuditMessage]
                           ([MessageId]
                           ,[MessageType]
                           ,[SentTime]
                           ,[OriginatingEndpoint]
                           ,[ProcessingEndpoint]
                           ,[BusinessKey]
                           ,[MessageBytes]
                           ,[PropertiesBytes])
                     VALUES
                           (@MessageId
                            ,@MessageType
                            ,@SentTime
                            ,@OriginatingEndpoint
                            ,@ProcessingEndpoint
                            ,@BusinessKey
                            ,@MessageBytes
                            ,@PropertiesBytes);";

           await connection.ExecuteAsync(sql, new {
                auditMessage.MessageId,
                auditMessage.MessageType,
                auditMessage.SentTime,
                auditMessage.OriginatingEndpoint,
                auditMessage.ProcessingEndpoint,
                auditMessage.BusinessKey,
                auditMessage.MessageBytes,
                auditMessage.PropertiesBytes});
        }
    }
}
