namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public interface IReleaseGroupService
    {
        Task ResetToAwaitingReleaseAndSendSlackMessage(IReadOnlyCollection<string> releaseGroupNames);
    }
}