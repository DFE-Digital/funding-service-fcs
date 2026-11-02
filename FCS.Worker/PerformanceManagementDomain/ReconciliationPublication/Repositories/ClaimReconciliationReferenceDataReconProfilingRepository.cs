namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class ClaimReconciliationReferenceDataReconProfilingRepository : IClaimReconciliationReferenceDataReconProfilingRepository
    {
        public async Task<bool> ShouldStaggerPayments(ConnectionInfo connectionInfo, string fundingPeriod, int ukprn)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext(connectionInfo))
            {
                return await context.ClaimReconciliationReferenceDataReconProfilings.AnyAsync(crrdrp =>
                    crrdrp.FundingPeriod == fundingPeriod &&
                    crrdrp.Ukprn == ukprn);
            }
        }
    }
}