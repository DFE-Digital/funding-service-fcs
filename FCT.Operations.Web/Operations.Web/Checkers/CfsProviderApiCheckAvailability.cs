namespace Operations.Web.Checkers
{
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    public class CfsProviderApiCheckAvailability : ICheckAvailability
    {
        public string ServiceName => "CFS Provider API";

        private readonly IConnectivityRepository _connectivityRepository;

        public CfsProviderApiCheckAvailability(IConnectivityRepository connectivityRepository)
        {
            _connectivityRepository = connectivityRepository;
        }

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            var result = await _connectivityRepository.GetAvailabilityCheckResult("CFS_PROVIDER_API");

            result.ServiceName = ServiceName;

            return result;
        }
    }
}