namespace FCT.Operations.Infrastructure
{
    using System.Data.SqlClient;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        private readonly IFcsConfiguration _configurationRoot;

        public SessionConnectionFactory(IFcsConfiguration configurationRoot)
        {
            _configurationRoot = configurationRoot;
        }

        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(
                context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }

        public ConnectionInfo GetReplicaConnection()
        {
            var connection = new SqlConnection(_configurationRoot["ConnectionStrings:MonitoringDeliverablesDbContext"]);

            return ConnectionInfo.CreateFrom(connection);
        }
    }
}