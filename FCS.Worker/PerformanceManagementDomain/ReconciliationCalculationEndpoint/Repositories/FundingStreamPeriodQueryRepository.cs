namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class FundingStreamPeriodQueryRepository : IFundingStreamPeriodQueryRepository
    {
        public async Task<IReadOnlyCollection<string>> GetPayOnProfileFundingStreamPeriodCodes(IReadOnlyCollection<string> fspCodes, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.FundingStreamPeriods
                    .Where(fsp => fspCodes.Contains(fsp.FundingStreamPeriodCode))
                    .Where(fsp => fsp.IsPayOnProfile)
                    .Select(fsp => fsp.FundingStreamPeriodCode)
                    .ToListAsync()
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}
