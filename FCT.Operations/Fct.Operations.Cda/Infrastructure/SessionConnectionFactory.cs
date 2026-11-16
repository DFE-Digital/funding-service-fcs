namespace FCT.Operations.Cda.Infrastructure
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using NServiceBus.Persistence;
    using NServiceBus.Persistence.Sql;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {

            var storageSession = context.SynchronizedStorageSession;

            // Convert to SQL persistence session (new NSB8 API)
            var sqlSession = storageSession.SqlPersistenceSession();

            return new ConnectionInfo(
                sqlSession.Transaction,
                sqlSession.Connection);
        }
    }
}