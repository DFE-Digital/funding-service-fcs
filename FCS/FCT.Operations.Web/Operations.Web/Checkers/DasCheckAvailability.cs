namespace Operations.Web.Checkers
{
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    public class DasCheckAvailability : ICheckAvailability
    {
        public string ServiceName => "DAS";

        private readonly IConnectivityRepository _connectivityRepository;

        public DasCheckAvailability(IConnectivityRepository connectivityRepository)
        {
            _connectivityRepository = connectivityRepository;
        }

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            var result = await _connectivityRepository.GetAvailabilityCheckResult(ServiceName);

            result.ServiceName = ServiceName;

            return result;
        }
    }
}