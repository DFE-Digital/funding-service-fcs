namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }
    }
}
