namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Infrastructure
{
    using CrossDomain.Integration.Entities.Data;
    using NServiceBus;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
