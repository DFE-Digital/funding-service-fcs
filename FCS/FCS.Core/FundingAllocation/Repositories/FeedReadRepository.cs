namespace FundingAllocation.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using DataStore.Model;
    using Dto;
    using Microsoft.EntityFrameworkCore;

    public class FeedReadRepository : IFeedReadRepository
    {
        private readonly FundingAllocationContext _context;

        public FeedReadRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<int> CreateRead()
        {
            var feedRead = new FeedRead();
            await _context.FeedReads.AddAsync(feedRead);
            await _context.SaveChangesAsync();

            return feedRead.ReadId;
        }

        public async Task<bool> HasLastJobCompleted()
        {
            const string sql = "SELECT Top 1 JobCompletedDate from [FundingAllocation].[FeedRead]" +
                               "ORDER BY [CreatedDate] DESC";

            var lastJobCompleted = (await _context.Database
                    .GetDbConnection()
                    .QueryAsync<DateTime?>(sql: sql, transaction: _context.CurrentTransaction))
                .DefaultIfEmpty(DateTime.UtcNow)
                .First();

            return lastJobCompleted.HasValue;
        }

        public async Task<CheckForReadCompleteResult> IsReadComplete(string fundingId)
        {

            var readInfo = (await _context.Database.GetDbConnection().QueryAsync<ReadInfo>("FundingAllocation.IsReadComplete @fundingId", new { fundingId },
                transaction: _context.CurrentTransaction)).Single();

            return new CheckForReadCompleteResult(readInfo.IsReadComplete, readInfo.ReadId);
        }

        public async Task<bool> SetToCompleteIfNotAlready(int readId)
        {
            var result = false;
            var rowsAffected = await _context.FeedReads.SingleOrDefaultAsync(fa => fa.ReadId == readId && fa.CfsReadCompletedDate == null);            
            if (rowsAffected!=null)
            {
                rowsAffected.CfsReadCompletedDate = DateTime.Now;
                _context.FeedReads.Attach(rowsAffected);
                _context.Entry(rowsAffected).Property(r => r.CfsReadCompletedDate).IsModified = true;
                _context.FeedReads.Update(rowsAffected);
                await _context.SaveChangesAsync();
                return result = true;
               
            }
            return result;
            
        }

        private class ReadInfo
        {
            public ReadInfo(int readId, int pagesYetToRead, int totalFAsWithMissingProviders)
            {
                ReadId = readId;
                PagesYetToRead = pagesYetToRead;
                TotalFAsWithMissingProviders = totalFAsWithMissingProviders;
            }

            public int ReadId { get; }
            public int PagesYetToRead { get; }
            public int TotalFAsWithMissingProviders { get; }
            public bool IsReadComplete => PagesYetToRead == 0 && TotalFAsWithMissingProviders == 0;
        }

        private class JobCompleteInfo
        {
            public int ReadId { get; set; }
            public DateTime? JobCompletedDate { get; set; }
        }
    }
}
