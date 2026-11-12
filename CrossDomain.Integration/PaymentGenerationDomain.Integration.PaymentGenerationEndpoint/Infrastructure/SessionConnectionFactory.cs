namespace PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.Infrastructure
{
    extern alias Entities;
    using NServiceBus;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }
    }
}