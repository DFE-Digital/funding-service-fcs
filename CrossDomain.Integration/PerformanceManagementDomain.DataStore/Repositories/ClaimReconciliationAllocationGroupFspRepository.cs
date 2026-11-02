namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public class ClaimReconciliationAllocationGroupFspRepository : 
        PerformanceManagementRepositoryBase<ClaimReconciliationAllocationGroupFsp>,
        IClaimReconciliationAllocationGroupFspRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;
        private static IReadOnlyCollection<string> _validFundingStreamPeriods = new List<string>();

        public ClaimReconciliationAllocationGroupFspRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.ClaimReconciliationAllocationGroupFsps)
        {
            _dbContext = dbContext;
        }

        public ClaimReconciliationAllocationGroupFsp GetClaimAllocationGroupForFundingStreamPeriod(string fundingStreamPeriod)
        {
            return _dbContext.ClaimReconciliationAllocationGroupFsps
                .Where(c => c.FspCode == fundingStreamPeriod)
                .Include(c=>c.ClaimReconciliationAllocationGroup)
                .SingleOrDefault();
        }

        public bool IsFundingStreamPeriodValid(string fundingStreamPeriod)
        {
            return GetValidFundingStreamPeriods().Contains(fundingStreamPeriod);
        }

        private IReadOnlyCollection<string> GetValidFundingStreamPeriods()
        {
            if (!_validFundingStreamPeriods.Any())
            {
                _validFundingStreamPeriods = _dbContext.ClaimReconciliationAllocationGroupFsps.Select(fsp => fsp.FspCode)
                    .ToList();
            }

            return _validFundingStreamPeriods;
        }
    }
}
