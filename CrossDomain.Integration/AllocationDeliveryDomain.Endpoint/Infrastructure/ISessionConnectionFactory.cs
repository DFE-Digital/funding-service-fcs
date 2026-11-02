namespace AllocationDeliveryDomain.Endpoint.Infrastructure
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
