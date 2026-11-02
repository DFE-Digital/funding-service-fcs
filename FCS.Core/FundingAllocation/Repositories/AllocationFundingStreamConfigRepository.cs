namespace FundingAllocation.Repositories
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using LanguageExt;
    using Microsoft.EntityFrameworkCore;

    public class AllocationFundingStreamConfigRepository : IAllocationFundingStreamConfigRepository
    {
        private readonly FundingAllocationContext _context;

        public AllocationFundingStreamConfigRepository(FundingAllocationContext context)
        {
            _context = context;
        }
        public async Task<Option<(string FSPGroupCode, string FundingPeriodCode, string FundingTypeCode)>> TryGetAllocationFundingStreamConfig(
            string allocationFundingStreamCode, string allocationPeriodId)
        {
            var rows = await _context.AllocationFundingStreamConfigRows.Where(afs =>
                    afs.AllocationFundingStreamCode == allocationFundingStreamCode &&
                    afs.AllocationPeriodId == allocationPeriodId)
                .Select(afs => new { afs.FSPGroupCode, afs.FundingPeriodCode, afs.FundingTypeCode })
                .ToListAsync();

            var row = rows.SingleOrDefault();

            return row == null
                ? Option<(string FSPGroupCode, string FundingPeriodCode, string FundingTypeCode)>.None
                : (row.FSPGroupCode, row.FundingPeriodCode, row.FundingTypeCode);
        }

        public async Task<(string FSPGroupCode, string FundingPeriodCode, string FundingTypeCode)> GetAllocationFundingStreamConfig(
            string allocationFundingStreamCode, string allocationPeriodId)
        {
            var allocationFundingStreamConfigOption =  await TryGetAllocationFundingStreamConfig(allocationFundingStreamCode, allocationPeriodId);

            return allocationFundingStreamConfigOption.Match(
                Some: c => c,
                None: () => throw new ArgumentException(
                    $"Cannot get AllocationFundingStreamConfig for allocationFundingStreamCode: {allocationFundingStreamCode}, " +
                    $"allocationPeriodId: {allocationPeriodId}"));
        }
    }
}
