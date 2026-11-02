namespace Operations.Web.Checkers
{
    using System.Threading.Tasks;
    using Dtos;
    using Repositories;

    public class CfsNotificationFeedCheckAvailability : ICheckAvailability
    {
        public string ServiceName => "CFS Notifications Feed";
        
        private readonly IConnectivityRepository _connectivityRepository;

        public CfsNotificationFeedCheckAvailability(IConnectivityRepository connectivityRepository)
        {
            _connectivityRepository = connectivityRepository;
        }

        public async Task<AvailabilityCheckResult> GetCheckResult()
        {
            var result = await _connectivityRepository.GetAvailabilityCheckResult("CFS_API");

            result.ServiceName = ServiceName;

            return result;
        }
    }
}