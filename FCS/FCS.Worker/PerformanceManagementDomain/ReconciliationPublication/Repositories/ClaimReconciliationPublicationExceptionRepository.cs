namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class ClaimReconciliationPublicationExceptionRepository : IClaimReconciliationPublicationExceptionRepository
    {
        public async Task<bool> IsForManualPublication(ConnectionInfo connectionInfo, string claimReconciliationAllocationGroupCode, int ukprn)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext(connectionInfo))
            {
                return await context.ClaimReconciliationPublicationExceptions.AnyAsync(c =>
                    c.ClaimReconciliationAllocationGroupCode == claimReconciliationAllocationGroupCode &&
                    c.Ukprn == ukprn);
            }
        }
    }
}