namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using ClaimType = SFA.FCT.PerformanceManagementDomain.DataStore.Models.ClaimType;

    public class ClaimTypeRepository : IClaimTypeRepository
    {
        public async Task<ClaimType> FindByName(string claimTypeName, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ClaimTypes.SingleAsync(ct => ct.Name == claimTypeName).ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}