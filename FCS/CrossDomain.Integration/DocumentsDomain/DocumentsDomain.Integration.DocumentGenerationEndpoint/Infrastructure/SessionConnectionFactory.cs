namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.Infrastructure
{
    using CrossDomain.Integration.Entities.Data;
    using DocumentGeneration.Infrastructure;
    using NServiceBus;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }
    }

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
