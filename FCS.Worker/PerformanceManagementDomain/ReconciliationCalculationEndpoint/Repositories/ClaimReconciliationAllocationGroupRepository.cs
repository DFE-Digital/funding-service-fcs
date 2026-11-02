namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationAllocationGroupRepository : IClaimReconciliationAllocationGroupRepository
    {
        public async Task<ClaimReconciliationAllocationGroup> Find(string allocationGroupCode, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ClaimReconciliationAllocationGroups.SingleAsync(crag =>
                        crag.ClaimReconciliationAllocationGroupCode == allocationGroupCode)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}