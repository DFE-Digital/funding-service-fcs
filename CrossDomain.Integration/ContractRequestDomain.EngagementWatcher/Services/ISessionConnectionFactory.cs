namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
