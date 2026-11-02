using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Linq;

    public class ClaimTypeRepository : PerformanceManagementRepositoryBase<ClaimType>, IClaimTypeRepository
    {
        private IPerformanceManagementDbContext _dbContext;

        public ClaimTypeRepository(IPerformanceManagementDbContext dbContext) : base(dbContext.ClaimTypes)
        {
            _dbContext = dbContext;
        }

        public ClaimType FindByName(string claimTypeName)
        {
            return _dbContext.ClaimTypes.Single(ct => ct.Name == claimTypeName);
        }
    }
}
