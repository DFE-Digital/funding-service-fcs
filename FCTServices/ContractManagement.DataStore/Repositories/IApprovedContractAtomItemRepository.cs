namespace ContractManagement.DataStore.Repositories
{
    using System;
    using Model;

    public interface IApprovedContractAtomItemRepository : IAtomItemRepository
    {
        Guid? GetIdentifierForBusinessKey(string businessKey, AtomItemType atomItemType);
    }
}
