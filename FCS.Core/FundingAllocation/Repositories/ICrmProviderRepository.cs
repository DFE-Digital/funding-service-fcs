namespace FundingAllocation.Repositories
{
    using System.Threading.Tasks;

    public interface ICrmProviderRepository
    {
        Task<string> GetProviderEntityReference(string ukprn);
    }
}