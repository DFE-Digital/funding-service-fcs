namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Infrastructure
{
    using CrossDomain.Integration.Entities.Data;
    using NServiceBus;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }
    }
}