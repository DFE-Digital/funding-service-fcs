namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload
{
    using CrossDomain.Integration.Entities.Data;
    using NServiceBus;

    public interface ISessionConnectionFactory
    {
        ConnectionInfo GetConnection(IMessageHandlerContext context);
    }
}