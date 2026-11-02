namespace FCT.Operations.Cda.Repositories
{
    using System;
    using System.Data.SqlClient;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        public bool Add(
            string messageId,
            string processingEndpoint,
            ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                const string sql = @"insert into [Operations].[ProcessedMessage]
                                     ([MessageId],
                                      [ProcessingEndpoint])
                                     values(@messageId, @processingEndpoint)";

                connectionInfo.Connection.Execute(
                    sql: sql,
                    transaction: connectionInfo.Transaction,
                    param: new {messageId, processingEndpoint});

                return true;
            }
            catch (SqlException ex)
                when (ex.Number == violationOfPrimaryKeyConstraint)
            {
                return false;
            }
        }
    }
}
