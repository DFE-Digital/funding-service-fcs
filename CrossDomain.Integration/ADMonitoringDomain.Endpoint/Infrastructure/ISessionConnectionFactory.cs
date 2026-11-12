namespace ADMonitoringDomain.Endpoint.Infrastructure
{
    extern alias Entities;
    using NServiceBus;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
