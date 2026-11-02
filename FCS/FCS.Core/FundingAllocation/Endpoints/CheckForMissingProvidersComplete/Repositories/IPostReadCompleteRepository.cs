namespace FundingAllocation.Endpoints.CheckForMissingProvidersComplete.Repositories
{
    using System.Threading.Tasks;

    public interface IPostReadCompleteRepository
    {
        Task<bool> IsPostReadMissingProviderCheckComplete();
    }
}