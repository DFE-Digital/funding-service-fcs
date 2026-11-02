namespace FundingAllocation.Repositories
{
    using System;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;
    using System.Linq;

    public class JobCompleteRepository : IJobCompleteRepository
    {
        private static readonly string[] PreContractControlStatuses =
        {
            FundingAllocationStatus.Parked.ToString(),
            FundingAllocationStatus.Discarded.ToString(),
        };

        private readonly FundingAllocationContext _context;

        public JobCompleteRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<bool> IsJobComplete(int readId)
        {
            // A Job is completed when a CRM entity id set on all Function allocations, or the function allocations are all either parked or discarded.
            // This query gets the top funding allocation where neither of those completed states exist.
            var incompleteFundingIdsCount = await (from res in _context.FundingAllocations
                                where res.ReadId == readId
                                && res.CrmEntityId == null
                                && (res.Status == null || !PreContractControlStatuses.Contains(res.Status)) select res).CountAsync();

            return incompleteFundingIdsCount == 0;
        }

        public async Task SetJobComplete(int readId)
        {
            // nb. Cfs must also have been completed, so just in-case set it here.

            var res = await _context.FeedReads.SingleOrDefaultAsync(fa => fa.ReadId == readId && fa.JobCompletedDate==null);
            if (res != null)
            {
                res.JobCompletedDate = DateTime.UtcNow;               
                _context.FeedReads.Attach(res);
                _context.Entry(res).Property(r => r.JobCompletedDate).IsModified = true;
                _context.FeedReads.Update(res);
                await _context.SaveChangesAsync();
            }
        }

        public async Task SetCfsReadComplete(int readId)
        {
            var res = await _context.FeedReads.SingleOrDefaultAsync(fa => fa.ReadId == readId && fa.JobCompletedDate == null);
            if (res != null)
            {
                res.CfsReadCompletedDate = DateTime.UtcNow;
                _context.FeedReads.Attach(res);
                _context.Entry(res).Property(r => r.CfsReadCompletedDate).IsModified = true;
                _context.FeedReads.Update(res);
                await _context.SaveChangesAsync();
            }
        }
    }
}