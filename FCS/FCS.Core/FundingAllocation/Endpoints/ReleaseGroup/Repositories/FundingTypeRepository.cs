namespace FundingAllocation.Endpoints.ReleaseGroup.Repositories
{
    using System.Collections.Concurrent;
    using System.Threading.Tasks;
    using System.Linq;
    using DataStore;
    using Infrastructure;
    using Microsoft.EntityFrameworkCore;

    public class FundingTypeRepository : IFundingTypeRepository
    {
        private readonly FundingAllocationContext _context;
        private static readonly ConcurrentDictionary<string, AsyncLazy<string>> ContractNumberPrefixes = new ConcurrentDictionary<string, AsyncLazy<string>>();

        public FundingTypeRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<string> GetContractNumberPrefix(string fundingTypeCode)
        {
            AsyncLazy<string> contractNumberPrefixLazy = new AsyncLazy<string>(() => GetDataFromDb(fundingTypeCode));

            return await ContractNumberPrefixes.GetOrAdd(fundingTypeCode, contractNumberPrefixLazy).Value;
        }

        private async Task<string> GetDataFromDb(string fundingTypeCode)
        {
            return await _context.FundingTypeConfigRows
                .Where(ft => ft.FundingTypeCode == fundingTypeCode)
                .Select(ft => ft.ContractReferencePrefix)
                .SingleAsync();
        }
    }
}