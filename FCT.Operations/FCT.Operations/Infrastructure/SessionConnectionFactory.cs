namespace FCT.Operations.Infrastructure
{
    using System.Data.SqlClient;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;
    using NServiceBus.Persistence;
    using NServiceBus.Persistence.Sql;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        private readonly IFcsConfiguration _configurationRoot;

        public SessionConnectionFactory(IFcsConfiguration configurationRoot)
        {
            _configurationRoot = configurationRoot;
        }

        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            var storageSession = context.SynchronizedStorageSession;

            // Convert to SQL persistence session (new NSB8 API)
            var sqlSession = storageSession.SqlPersistenceSession();

            return new ConnectionInfo(
                sqlSession.Transaction,
                sqlSession.Connection);
        }

        public ConnectionInfo GetReplicaConnection()
        {
            var connection = new SqlConnection(_configurationRoot["ConnectionStrings:MonitoringDeliverablesDbContext"]);

            return ConnectionInfo.CreateFrom(connection);
        }
    }
}