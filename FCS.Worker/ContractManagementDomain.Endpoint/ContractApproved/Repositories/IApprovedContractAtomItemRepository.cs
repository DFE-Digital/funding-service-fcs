namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IApprovedContractAtomItemRepository
    {
        Task Add(AtomFeedItem atomFeedItem, ConnectionInfo connectionInfo);

        Task<Guid?> GetIdentifierForBusinessKey(string businessKey, AtomItemType atomItemType, ConnectionInfo connectionInfo);
    }
}
