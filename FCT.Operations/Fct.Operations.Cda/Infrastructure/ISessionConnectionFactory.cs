namespace FCT.Operations.Cda.Infrastructure
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}