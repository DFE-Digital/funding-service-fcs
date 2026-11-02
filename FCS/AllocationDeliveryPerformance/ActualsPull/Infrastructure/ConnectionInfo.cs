namespace ActualsPull.Infrastructure
{
    using System.Data;
    using System.Data.Common;

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

        public DbTransaction Transaction { get; }

        public IDbConnection Connection { get; }

        public bool UseDefault()
        {
            return Transaction == null && Connection == null;
        }
    }
}
