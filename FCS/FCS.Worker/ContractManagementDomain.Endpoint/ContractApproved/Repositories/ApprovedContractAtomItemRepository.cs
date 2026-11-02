namespace ContractManagementDomain.Endpoint.ContractApproved.Repositories
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Exceptions;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ApprovedContractAtomItemRepository : IApprovedContractAtomItemRepository
    {
        public async Task Add(AtomFeedItem atomFeedItem, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                try
                {
                    context.AtomFeedItems.Add(atomFeedItem);
                    await context.SaveChangesAsync()
                        .ConfigureAwait(false);
                }
                catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException exception && exception.Number == 2601) // Handle duplicate key exception
                {
                    throw new SqlDuplicateKeyStorageException(ex);
                }
            }
        }

        public async Task<Guid?> GetIdentifierForBusinessKey(string businessKey, AtomItemType atomItemType, ConnectionInfo connectionInfo)
        {
            using (ContractManagementDbContext context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                AtomFeedItem atomFeedItem = await context.AtomFeedItems
                    .SingleOrDefaultAsync(afi => afi.BusinessKey == businessKey && afi.ItemType == atomItemType)
                    .ConfigureAwait(false);

                return atomFeedItem?.Identifier;
            }
        }
    }
}
