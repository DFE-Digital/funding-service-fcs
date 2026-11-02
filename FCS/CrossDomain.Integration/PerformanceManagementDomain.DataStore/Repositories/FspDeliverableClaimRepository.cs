namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Models;

    public class FspDeliverableClaimRepository : IFspDeliverableClaimRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;

        public FspDeliverableClaimRepository(IPerformanceManagementDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public List<FspDeliverableClaim> GetFspDeliverablesIncludingClaimDeliverableGroup(string fundingStreamPeriodCode)
        {
            return _dbContext.FspDeliverableClaims.Where(fspDel => fspDel.FspCode == fundingStreamPeriodCode
                                                                   && fspDel.ClaimReconciliationDeliverableGroupCode != null)
                .Include(x => x.ClaimReconciliationDeliverableGroup).ToList();
        }

        public string GetDeliverableName(int deliverableCode, string fundingStreamPeriodCode)
        {
            return _dbContext.FspDeliverableClaims.SingleOrDefault(d => d.FspCode == fundingStreamPeriodCode && d.DeliverableCode == deliverableCode)?.DeliverableName;
        }
    }
}
