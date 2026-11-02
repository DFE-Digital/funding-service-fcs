namespace FundingAllocation.Endpoints.EnrichProviderFunding.Repositories
{
    using System.Threading.Tasks;
    using DataStore.Model;

    public interface IProviderFundingAllocationRepository
    {
        Task Create(ProviderFundingAllocation providerFundingAllocation);
    }
}
