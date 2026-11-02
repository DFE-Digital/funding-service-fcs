namespace SFA.FCT.DocumentsDomain.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;

    public interface IProcessedMessageRepository
    {
        bool Add(string messageId, string processingEndpoint, ConnectionInfo connectionInfo);
    }
}