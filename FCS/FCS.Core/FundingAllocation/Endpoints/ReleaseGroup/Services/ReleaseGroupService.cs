namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System.Linq;
    using Repositories;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using DataStore.Model;

    public class ReleaseGroupService : IReleaseGroupService
    {
        private readonly ICrmReleaseGroupRepository _crmReleaseGroupRepository;
        private readonly IReleaseGroupRepository _releaseGroupRepository;
        private readonly ISlackNotificationService _slackNotificationService;

        public ReleaseGroupService(ICrmReleaseGroupRepository crmReleaseGroupRepository, 
            IReleaseGroupRepository releaseGroupRepository, 
            ISlackNotificationService slackNotificationService)
        {
            _crmReleaseGroupRepository = crmReleaseGroupRepository;
            _releaseGroupRepository = releaseGroupRepository;
            _slackNotificationService = slackNotificationService;
        }

        public async Task ResetToAwaitingReleaseAndSendSlackMessage(IReadOnlyCollection<string> releaseGroupNames)
        {
            await _releaseGroupRepository.UpdateStatus(releaseGroupNames, ReleaseGroupStatus.AwaitingRelease);

            var crmEntityIds = await _releaseGroupRepository.GetCrmEntityIds(releaseGroupNames);

            crmEntityIds.ToList().ForEach(async crmEntityId => await _crmReleaseGroupRepository.SetToAwaitingRelease(crmEntityId));

            await _slackNotificationService.ReleaseOfReleaseGroupsPreventedDueToBulkImportBeingInProgress(releaseGroupNames);
        }
    }
}