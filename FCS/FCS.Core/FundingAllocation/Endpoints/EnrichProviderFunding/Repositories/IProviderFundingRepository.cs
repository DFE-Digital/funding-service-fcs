namespace FundingAllocation.Endpoints.EnrichProviderFunding.Repositories
{
    using System.Threading.Tasks;
    using DataStore.Model;

    public interface IProviderFundingRepository
    {
        Task<bool> IsProviderFundingInDb(string providerFundingId);

        Task Create(ProviderFunding providerFunding);
    }
}