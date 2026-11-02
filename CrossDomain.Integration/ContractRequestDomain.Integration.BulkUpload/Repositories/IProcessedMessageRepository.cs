namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Repositories
{
    using CrossDomain.Integration.Entities.Data;

    public interface IProcessedMessageRepository
    {
        bool Add(string messageId);

        bool Add(string messageId, ConnectionInfo connectionInfo);
    }
}
