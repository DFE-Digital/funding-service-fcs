namespace ContractManagement.DataStore.Repositories
{
    using Model;

    public interface IAtomItemCommandRepository
    {
        void Add(AtomFeedItem atomFeedItem);
    }
}
