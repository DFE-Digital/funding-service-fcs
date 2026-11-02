namespace FundingAllocation.Endpoints.EnrichProviderFunding.Repositories
{
    using System.Threading.Tasks;
    using DataStore;
    using DataStore.Model;

    public class ProviderFundingAllocationRepository : IProviderFundingAllocationRepository
    {
        private readonly FundingAllocationContext _context;

        public ProviderFundingAllocationRepository(FundingAllocationContext context)
        {
            _context = context;
        }

        public async Task Create(ProviderFundingAllocation providerFundingAllocation)
        {
            await _context.ProviderFundingAllocations.AddAsync(providerFundingAllocation);
            await _context.SaveChangesAsync();
        }
    }
}