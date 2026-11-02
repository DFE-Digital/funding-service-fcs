namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    
    public interface ISlackNotificationService
    {
        Task ReleaseOfReleaseGroupsPreventedDueToBulkImportBeingInProgress(IReadOnlyCollection<string> releaseGroupNames);
    }
}