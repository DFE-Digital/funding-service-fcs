namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories
{
    using System.Data;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using CrossDomain.Integration.Entities.Data;

    public class ProcessedMessageRepository : IProcessedMessageRepository
    {
        private readonly IDbConnection _connection;

        public ProcessedMessageRepository(IDbConnection connection)
        {
            _connection = connection;
        }

        public ProcessedMessageRepository()
        {

        }

        public bool Add(string messageId)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                IDbCommand command = _connection.CreateCommand();
                command.CommandText = "INSERT INTO ContractManagement.ProcessedMessage (MessageId) VALUES (@messageId)";
                
                IDbDataParameter parameter = command.CreateParameter();
                parameter.ParameterName = "@messageId";
                parameter.Value = messageId;
                command.Parameters.Add(parameter);
                
                command.ExecuteNonQuery();

                return true;
            }
            catch (SqlException ex) when (ex.Number == violationOfPrimaryKeyConstraint)
            {
                return false;
            }
        }

        public bool Add(string messageId, ConnectionInfo connectionInfo)
        {
            const int violationOfPrimaryKeyConstraint = 2627;

            try
            {
                IDbCommand command = connectionInfo.Connection.CreateCommand();
                command.CommandText = "INSERT INTO ContractManagement.ProcessedMessage (MessageId) VALUES (@messageId)";

                IDbDataParameter parameter = command.CreateParameter();
                parameter.ParameterName = "@messageId";
                parameter.Value = messageId;
                command.Parameters.Add(parameter);
                command.Transaction = connectionInfo.Transaction;

                command.ExecuteNonQuery();

                return true;
            }
            catch (DbUpdateException ex)
                when (ex.InnerException?.InnerException is SqlException && ((SqlException)ex.InnerException.InnerException).Number == violationOfPrimaryKeyConstraint)
            {
                return false;
            }
        }
    }
}