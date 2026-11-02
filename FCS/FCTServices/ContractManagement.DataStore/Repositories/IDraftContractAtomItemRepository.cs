namespace ContractManagement.DataStore.Repositories
{
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IDraftContractAtomItemRepository : IAtomItemRepository
    {
        void Add(AtomFeedItem atomFeedItem, ConnectionInfo connectionInfo);
    }
}