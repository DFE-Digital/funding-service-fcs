namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class AtomFeedItemRepository : IAtomFeedItemRepository
    {
        private const int SqlUniqueindexViolationcode = 2601;

        public async Task Add(ConnectionInfo connectionInfo, AtomFeedItem atomFeedItem)
        {
            try
            {
                using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
                {
                    dbContext.AtomFeedItems.Add(atomFeedItem);
                    await dbContext.SaveChangesAsync();
                }
            }
            catch (DbUpdateException ex) when (ex.InnerException?.InnerException is SqlException exception && exception.Number == SqlUniqueindexViolationcode) // Handle duplicate key exception
            {
                throw new DuplicateKeyStorageException(ex);
            }
        }

        public async Task<AtomFeedItem> GetByUkprnClaimTypeAllocationGroupAndPeriod(ConnectionInfo connectionInfo, int ukprn, string claimTypeName, string allocationGroup, string period)
        {
            using (PerformanceManagementDbContext dbContext = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await dbContext.AtomFeedItems.SingleAsync(atomItem =>
                    atomItem.Ukprn == ukprn &&
                    atomItem.ClaimTypeName == claimTypeName &&
                    atomItem.AllocationGroupName == allocationGroup &&
                    atomItem.Period == period);
            }
        }
    }
}
