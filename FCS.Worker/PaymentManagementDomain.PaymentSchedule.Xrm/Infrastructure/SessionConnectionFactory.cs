namespace PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure
{
    extern alias IntegrationEntities;
    using NServiceBus;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using NServiceBus.Persistence;
    using NServiceBus.Persistence.Sql;
    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            // Get the synchronized storage session (still valid in NSB8)
            var storageSession = context.SynchronizedStorageSession;

            // Convert to SQL persistence session (new NSB8 API)
            var sqlSession = storageSession.SqlPersistenceSession();

            return new ConnectionInfo(
                sqlSession.Transaction,
                sqlSession.Connection);
        }
    }
}
