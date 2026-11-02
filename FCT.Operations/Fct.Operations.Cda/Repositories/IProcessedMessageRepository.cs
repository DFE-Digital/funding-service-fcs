namespace FCT.Operations.Cda.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IProcessedMessageRepository
    {
        bool Add(
            string messageId,
            string processingEndpoint,
            ConnectionInfo connectionInfo);
    }
}
