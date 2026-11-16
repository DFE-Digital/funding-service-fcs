namespace PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure
{
    extern alias IntegrationEntities;
    using NServiceBus;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
