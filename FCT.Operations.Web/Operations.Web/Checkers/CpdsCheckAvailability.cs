namespace Operations.Web.Checkers
{
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    public class CpdsCheckAvailability : ICheckAvailability
    {
        public string ServiceName => "CPDS";

        private readonly IConnectivityRepository _connectivityRepository;

        public CpdsCheckAvailability(IConnectivityRepository connectivityRepository)
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