namespace PerformanceManagementDomain.PullFundingClaim.Services
{
    using System.Threading.Tasks;

    public interface IHttpService
    {
        Task<string> GetAsync(string authorizationToken, string requestUri);
    }
}