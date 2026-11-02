namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;

    public class FundingAllocationPageControlRepository : IFundingAllocationPageControlRepository
    {
        private readonly FundingAllocationContext _context;


        public FundingAllocationPageControlRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<FundingAllocationPageControl> GetLatest()
        {
            return await _context.FundingAllocationPageControls
                .AsNoTracking()
                .OrderByDescending(pc => pc.ReadId)
                .ThenByDescending(pc => pc.PageNumber)
                .FirstOrDefaultAsync();
        }

        public async Task InsertPage(int readId, int pageNumber)
        {
            await _context.FundingAllocationPageControls.AddAsync(new FundingAllocationPageControl(readId, pageNumber));

            await _context.SaveChangesAsync();
        }

        public async Task SetLatestBookmark(int readId, int pageNumber, string latestBookmarkOnPage)
        {
            var storedEntity = await _context.FundingAllocationPageControls.FindAsync(readId, pageNumber);

            storedEntity.LatestBookmarkOnPage = latestBookmarkOnPage;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> IsThereAnyNewDataToConsume(IReadOnlyCollection<string> fundingIdsOnFeed, int pageNumber)
        {
            var matchingRows = await (from res in _context.FundingAllocations
                                where fundingIdsOnFeed.Contains(res.FundingId)
                                select res).CountAsync();

            return matchingRows != fundingIdsOnFeed.Count;
        }
    }
}
