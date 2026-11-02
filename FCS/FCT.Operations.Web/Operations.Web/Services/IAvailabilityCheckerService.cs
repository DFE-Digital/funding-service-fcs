namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface IAvailabilityCheckerService
    {
        IReadOnlyCollection<string> GetAvailabilityCheckerServiceNames();

        Task<AvailabilityCheckResult> GetAvailabilityCheckResultForService(string checker);
    }
}