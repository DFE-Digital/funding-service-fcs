namespace Operations.Web.Repositories
{
    using System.Threading.Tasks;
    using Dtos;

    public interface IConnectivityRepository
    {
        Task<AvailabilityCheckResult> GetAvailabilityCheckResult(string serviceName);
    }
}