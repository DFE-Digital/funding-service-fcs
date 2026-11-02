namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories
{
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationBehaviourRepository : IClaimReconciliationBehaviourRepository
    {
        private static readonly ConcurrentDictionary<string, ClaimReconciliationBehaviour> ClaimReconciliationBehaviourCache =
            new ConcurrentDictionary<string, ClaimReconciliationBehaviour>();

        public async Task<ClaimReconciliationBehaviour> Find(string claimCollectionCode, string claimAllocationGroup, ConnectionInfo connectionInfo)
        {
            string key = $"{claimCollectionCode}____{claimAllocationGroup}";

            if (!ClaimReconciliationBehaviourCache.ContainsKey(key))
            {
                var behaviour = await GetFromDb(claimCollectionCode, claimAllocationGroup, connectionInfo);

                ClaimReconciliationBehaviourCache.TryAdd(key, behaviour);

                return behaviour;
            }

            return ClaimReconciliationBehaviourCache[key];
        }

        private async Task<ClaimReconciliationBehaviour> GetFromDb(string claimCollectionCode, string claimAllocationGroup, ConnectionInfo connectionInfo)
        {
            using (var context = new PerformanceManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return await context.ClaimReconciliationBehaviours.SingleAsync(crb =>
                        crb.ClaimCollectionCode == claimCollectionCode &&
                        crb.ClaimReconciliationAllocationGroupCode == claimAllocationGroup)
                    .ConfigureAwait(continueOnCapturedContext: false);
            }
        }
    }
}