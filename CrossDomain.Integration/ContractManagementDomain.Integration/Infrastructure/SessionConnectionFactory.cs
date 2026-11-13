
namespace SFA.FCT.ContractManagementDomain.Integration.Infrastructure
{
    using CrossDomain.Integration.Entities.Data;
    using NServiceBus;                 // IMessageHandlerContext, SynchronizedStorageSession
    using NServiceBus.Persistence.Sql; // SqlPersistenceSession() + ISqlStorageSession

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            var sqlSession = context.SynchronizedStorageSession.SqlPersistenceSession();
            return new ConnectionInfo(sqlSession.Transaction, sqlSession.Connection);
        }
    }
}
