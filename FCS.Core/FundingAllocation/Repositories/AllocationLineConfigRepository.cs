namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore;
    using Dto;
    using Microsoft.EntityFrameworkCore;

    public class AllocationLineConfigRepository : IAllocationLineConfigRepository
    {
        private readonly FundingAllocationContext _context;

        public AllocationLineConfigRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<IReadOnlyCollection<AllocationLineDeliverableInfo>> GetAllocationLineConfigs(
            string allocationFundingStreamCode,
            string allocationPeriodId,
            string fundingLineCode)
        {
            var allocationLineConfigs = await _context.Database.GetDbConnection().QueryAsync<AllocationLineDeliverableInfo>(
                "FundingAllocation.GetAllocationLineConfigs @allocationFundingStreamCode,@allocationPeriodId,@fundingLineCode",
                new { allocationFundingStreamCode, allocationPeriodId, fundingLineCode },
                transaction: _context.CurrentTransaction);

            return allocationLineConfigs.ToList();
        }
    }
}
