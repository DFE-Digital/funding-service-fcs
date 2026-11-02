namespace ContractCreateDomain.Endpoint.Infrastructure
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IProcessedMessageRepository
    {
        bool Add(string messageId, ConnectionInfo connectionInfo);
    }
}
