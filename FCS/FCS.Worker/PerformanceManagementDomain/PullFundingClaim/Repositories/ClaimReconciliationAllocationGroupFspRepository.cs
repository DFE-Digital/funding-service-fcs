namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class ClaimReconciliationAllocationGroupFspRepository : IClaimReconciliationAllocationGroupFspRepository
    {
        private static IReadOnlyCollection<string> _validFspCodes = new List<string>();
        private bool AreFspCodesLoaded => _validFspCodes.Any();

        public async Task<IReadOnlyCollection<string>> GetValidFundingStreamPeriodCodes(ConnectionInfo connectionInfo)
        {
            if (!AreFspCodesLoaded)
            {
                using (var context = new PerformanceManagementDbContext(connectionInfo: connectionInfo))
                {
                    _validFspCodes = await context.ClaimReconciliationAllocationGroupFsps
                        .AsNoTracking()
                        .Select(c => c.FspCode)
                        .ToListAsync()
                        .ConfigureAwait(false);
                }
            }

            return _validFspCodes;
        }
    }
}