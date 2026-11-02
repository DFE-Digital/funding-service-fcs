namespace FundingAllocation.Endpoints.EnrichProviderFunding.Services
{
    using System.Threading.Tasks;

    public interface IProviderService
    {
        Task CreateProviderFundingAllocation(string fundingId, string providerFundingId);
    }
}