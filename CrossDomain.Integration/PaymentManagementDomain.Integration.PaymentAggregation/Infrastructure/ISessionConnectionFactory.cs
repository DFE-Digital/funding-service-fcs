namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Infrastructure
{
    extern alias Entities;

    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using NServiceBus;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
