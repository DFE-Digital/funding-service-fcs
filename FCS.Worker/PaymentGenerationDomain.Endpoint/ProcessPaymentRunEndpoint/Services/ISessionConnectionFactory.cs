namespace PaymentGenerationDomain.Endpoint.ProcessPaymentRunEndpoint.Services
{
    extern alias CrossdomainCommon;
    using NServiceBus;
    using CrossdomainCommon::SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}
