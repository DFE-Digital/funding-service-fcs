namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Infrastructure
{
    using CrossDomain.Integration.Entities.Data;
    using NServiceBus;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
