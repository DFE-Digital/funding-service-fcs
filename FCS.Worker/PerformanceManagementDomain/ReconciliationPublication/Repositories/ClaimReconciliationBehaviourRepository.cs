namespace PerformanceManagementDomain.ReconciliationPublication.Repositories
{
    using System;
    using System.Collections.Concurrent;
    using System.Data.Entity;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationBehaviourRepository : IClaimReconciliationBehaviourRepository
    {
        private static readonly ConcurrentDictionary<string, ClaimReconciliationBehaviour> _cache = new ConcurrentDictionary<string, ClaimReconciliationBehaviour>();

        public async Task<bool> IsClaimCollectionPayable(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode)
        {
            ClaimReconciliationBehaviour claimReconciliationBehaviour = await FindByKey(connectionInfo, claimCollectionCode, claimReconciliationAllocationGroupCode);

            return claimReconciliationBehaviour.IsReconciliationPayable;
        }

        public async Task<bool> IsAfterPublicationCloseDate(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode, DateTime currentDate)
        {
            ClaimReconciliationBehaviour claimReconciliationBehaviour = await FindByKey(connectionInfo, claimCollectionCode, claimReconciliationAllocationGroupCode);

            if (claimReconciliationBehaviour.PublicationCloseDate.HasValue)
            {
                return currentDate.Date > claimReconciliationBehaviour.PublicationCloseDate;
            }

            return false;
        }

        private static async Task<ClaimReconciliationBehaviour> FindByKey(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode)
        {
            string cacheKey = $"{claimCollectionCode}_{claimReconciliationAllocationGroupCode}";

            if (!_cache.ContainsKey(cacheKey))
            {
                ClaimReconciliationBehaviour entity = await GetEntityFromDatabase(connectionInfo, claimCollectionCode, claimReconciliationAllocationGroupCode);
                _cache.TryAdd(cacheKey, entity);
            }

            return _cache[cacheKey];
        }

        private static async Task<ClaimReconciliationBehaviour> GetEntityFromDatabase(ConnectionInfo connectionInfo, string claimCollectionCode, string claimReconciliationAllocationGroupCode)
        {
            using (PerformanceManagementDbContext context = new PerformanceManagementDbContext(connectionInfo))
            {
                return await context.ClaimReconciliationBehaviours.SingleAsync(c =>
                    c.ClaimCollectionCode == claimCollectionCode &&
                    c.ClaimReconciliationAllocationGroupCode == claimReconciliationAllocationGroupCode);
            }
        }
    }
}