namespace ContractManagement.DataStore.Repositories
{
    using System;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovalOnwardsContractAtomItemRepository : IAtomItemRepository
    {
        Guid? GetIdentifierForBusinessKey(ConnectionInfo connectionInfo, string businessKey, AtomItemType atomItemType);

        void Add(ConnectionInfo connectionInfo, AtomFeedItem atomFeedItem);
    }
}