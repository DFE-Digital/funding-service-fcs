namespace FundingAllocation.Endpoints.EnrichProviderFunding.Repositories
{
    using System.Linq;
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;
    using Microsoft.EntityFrameworkCore;

    public class ProviderFundingRepository : IProviderFundingRepository
    {
        private readonly FundingAllocationContext _context;

        public ProviderFundingRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task<bool> IsProviderFundingInDb(string providerFundingId)
        {
            var rowCount = await _context.ProviderFundings
                .Where(pf => pf.ProviderFundingId == providerFundingId)
                .CountAsync();

            return rowCount > 0;
        }

        public async Task Create(ProviderFunding providerFunding)
        {
            await _context.ProviderFundings.AddAsync(providerFunding);

            await _context.SaveChangesAsync();
        }
    }
}
