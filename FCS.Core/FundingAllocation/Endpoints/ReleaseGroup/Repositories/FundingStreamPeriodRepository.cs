namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using Microsoft.EntityFrameworkCore;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        private readonly FundingAllocationContext _context;

        public FundingStreamPeriodRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<(DateTime startDate, DateTime endDate)> GetFspStartAndEndDate(string fspCode)
        {
           var matchingRow = await _context.FundingStreamPeriodConfigRows
                .AsNoTracking()
                .Where(fsp => fsp.FundingStreamPeriodCode == fspCode)
                .Select(fsp => new {fsp.StartDate, fsp.EndDate})
                .SingleAsync();

           return (DateTime.SpecifyKind(matchingRow.StartDate, DateTimeKind.Utc), DateTime.SpecifyKind(matchingRow.EndDate, DateTimeKind.Utc));
        }
    }
}
