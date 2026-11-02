namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Data.Entity;
    using System.Linq;
    using Models.Allocation;

    public class ContractAllocationRepository : PerformanceManagementRepositoryBase<ContractAllocation>, IContractAllocationRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;

        public ContractAllocationRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.ContractAllocations)
        {
            _dbContext = dbContext;
        }

        public ContractAllocation Find(string allocationNumber)
        {
            return FindByKey(new object[] {allocationNumber});
        }

        public int SaveChanges()
        {
            return _dbContext.SaveChanges();
        }

        public decimal? GetPlannedValueForAllocation(string allocationNumber)
        {
            return
                _dbContext.ContractAllocations.Include(ca => ca.ContractAllocationDeliverables)
                    .SingleOrDefault(ca => ca.AllocationNumber == allocationNumber)
                    ?.ContractAllocationDeliverables.Sum(d => d.PlannedValue);
        }
    }
}
