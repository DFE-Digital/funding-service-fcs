namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;

    public class ClaimReconciliationBehaviourAsyncRepository : IClaimReconciliationBehaviourAsyncRepository
    {
        public async Task<bool> DoesClaimCollectionCodeExist(string closedCollectionKey, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connection: connectionInfo.Connection,
                transaction: connectionInfo.Transaction))
            {
                return await context.ClaimReconciliationBehaviours.AnyAsync(b =>
                    b.ClaimCollectionCode == closedCollectionKey);
            }
        }
    }
}
