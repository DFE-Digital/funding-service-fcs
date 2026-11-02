namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using Models;

    public class ClaimReconciliationBehaviourRepository : LazyLoadCachedRepositoryBase<ClaimReconciliationBehaviour>, IClaimReconciliationBehaviourRepository
    {
        private readonly IDbSet<ClaimReconciliationBehaviour> _dbSet;

        public ClaimReconciliationBehaviourRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.ClaimReconciliationBehaviours)
        {
            _dbSet = dbContext.ClaimReconciliationBehaviours;
        }

        public ClaimReconciliationBehaviour Find(string claimCollectionCode, string claimReconciliationAllocationGroupCode)
        {
            return FindByKey(claimCollectionCode, claimReconciliationAllocationGroupCode);
        }

        public bool DoesClaimCollectionCodeExist(string closedCollectionKey)
        {
            return _dbSet.Any(b => b.ClaimCollectionCode == closedCollectionKey);
        }
    }
}
