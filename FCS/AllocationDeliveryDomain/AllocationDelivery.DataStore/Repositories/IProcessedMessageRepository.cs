namespace SFA.FCT.AllocationDelivery.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;

    public interface IProcessedMessageRepository
    {
        bool Add(string messageId, ConnectionInfo connectionInfo);
    }
}