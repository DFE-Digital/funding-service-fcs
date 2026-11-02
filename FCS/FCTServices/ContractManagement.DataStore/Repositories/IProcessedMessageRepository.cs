namespace ContractManagement.DataStore.Repositories
{
    public interface IProcessedMessageRepository
    {
        bool Add(string messageId);
    }
}
