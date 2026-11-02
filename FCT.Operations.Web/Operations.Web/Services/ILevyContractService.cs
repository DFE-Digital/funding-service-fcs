namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dtos;

    public interface ILevyContractService
    {
        IReadOnlyCollection<ContractInformation> GetLevyContractsThatCannotBeAmended();
        Task<bool> GetEngagementWatcherWebJobStatus();
        void UpdateStatusOfEngagementWatcherWebJobStatus(bool enabled, string username);
    }
}