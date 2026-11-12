namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint.Services
{
    extern alias CrossdomainCommon;
    using NServiceBus;
    using CrossdomainCommon::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class SessionConnectionFactory : ISessionConnectionFactory
    {
        public ConnectionInfo GetConnection(IMessageHandlerContext context)
        {
            return new ConnectionInfo(context.SynchronizedStorageSession.SqlPersistenceSession().Transaction,
                context.SynchronizedStorageSession.SqlPersistenceSession().Connection);
        }
    }
}