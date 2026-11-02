using System.Linq;
using System.Threading.Tasks;
using SFA.FCT.CrossDomain.Integration.Entities.Data;
using SFA.FCT.PerformanceManagementDomain.DataStore;
using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Data.Entity;

    public class ClaimReconciliationAllocationGroupFspRepository : IClaimReconciliationAllocationGroupFspRepository
    {
        public async Task<ClaimReconciliationAllocationGroupFsp> GetClaimAllocationGroupForFundingStreamPeriod(string fundingStreamPeriod, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ClaimReconciliationAllocationGroupFsps
                    .Where(c => c.FspCode == fundingStreamPeriod)
                    .Include(c => c.ClaimReconciliationAllocationGroup)
                    .SingleOrDefaultAsync();
            }
        }
    }
}