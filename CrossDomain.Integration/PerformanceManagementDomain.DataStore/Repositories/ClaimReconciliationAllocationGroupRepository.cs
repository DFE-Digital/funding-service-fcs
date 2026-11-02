namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationAllocationGroupRepository : PerformanceManagementRepositoryBase<ClaimReconciliationAllocationGroup>, IClaimReconciliationAllocationGroupRepository
    {
        private IPerformanceManagementDbContext _dbContext;

        public ClaimReconciliationAllocationGroupRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.ClaimReconciliationAllocationGroups)
        {
            _dbContext = dbContext;
        }

        public ClaimReconciliationAllocationGroup Find(string allocationGroupCode)
        {
            return FindByKey(new[] {allocationGroupCode});
        }
    }
}
