namespace SFA.FCS.Worker.Common
{
    using System.Data;
    using System.Data.Common;
    using Microsoft.Data.SqlClient;

    public class ConnectionInfo
    {
        public ConnectionInfo(DbTransaction transaction, IDbConnection connection)
        {
            Transaction = transaction;
            Connection = connection;
        }

        private ConnectionInfo()
        {
        }

        public static ConnectionInfo CreateDefault()
        {
            return new ConnectionInfo();
        }

        public static ConnectionInfo CreateFrom(DbConnection connection)
        {
            return new ConnectionInfo(transaction: null, connection: connection);
        }

        public static ConnectionInfo CreateFrom(string connectionString)
        {
            return new ConnectionInfo(transaction: null, connection: new SqlConnection(connectionString));
        }

        public DbTransaction Transaction { get; }

        public IDbConnection Connection { get; }

        public bool UseDefault()
        {
            return Transaction == null && Connection == null;
        }
    }
}
