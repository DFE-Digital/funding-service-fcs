namespace Operations.Web.Services
{
    using Dtos;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    public class AvailabilityCheckerService : IAvailabilityCheckerService
    {
        private readonly ICheckerFactory _checkerFactory;

        public AvailabilityCheckerService(ICheckerFactory checkerFactory)
        {
            _checkerFactory = checkerFactory;
        }

        public IReadOnlyCollection<string> GetAvailabilityCheckerServiceNames()
        {
            return _checkerFactory.GetAvailabilityCheckerDictionary().Keys.ToList();
        }

        public async Task<AvailabilityCheckResult> GetAvailabilityCheckResultForService(string serviceName)
        {
            var checkers = _checkerFactory.GetAvailabilityCheckerDictionary();

            Task<AvailabilityCheckResult> availabilityCheckResultTask = Task.FromResult<AvailabilityCheckResult>(null);

            if (checkers.ContainsKey(serviceName))
            {
                availabilityCheckResultTask = checkers[serviceName]();
            }

            return await availabilityCheckResultTask;
        }
    }
}