namespace ContractManagement.DataStore.Repositories
{
    using Model;

    public interface IIntegrityCheckRepository
    {
        IntegrityCheck Add(IntegrityCheck integrityCheck);
        void Update(IntegrityCheck integrityCheck);
    }
}
