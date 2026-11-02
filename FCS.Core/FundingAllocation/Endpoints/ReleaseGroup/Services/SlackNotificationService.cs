namespace FundingAllocation.Endpoints.ReleaseGroup.Services
{
    using System;
    using System.Threading.Tasks;
    using System.Collections.Generic;
    using System.Linq;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;
    using Repositories;
    using System.Text;

    public class SlackNotificationService : ISlackNotificationService
    {
        private readonly ISlackMessageSender _slackMessageSender;
        private readonly ILogger _logger;
        private readonly IConfigurationRoot _appConfiguration;
        private readonly IReleaseGroupRepository _releaseGroupRepository;

        public SlackNotificationService(ISlackMessageSender slackMessageSender,
            ILogger logger,
            IConfigurationRoot appConfiguration, 
            IReleaseGroupRepository releaseGroupRepository)
        {
            _slackMessageSender = slackMessageSender;
            _logger = logger;
            _appConfiguration = appConfiguration;
            _releaseGroupRepository = releaseGroupRepository;
        }

        public async Task ReleaseOfReleaseGroupsPreventedDueToBulkImportBeingInProgress(IReadOnlyCollection<string> releaseGroupNames)
        {
            var shouldSendToSlack = _appConfiguration["Slack:ShouldSend"];

            if (shouldSendToSlack == "true" && releaseGroupNames.Count > 0)
            {
                var releaseGroupFundingTypeFundingPeriodInfos = 
                    await _releaseGroupRepository.GetReleaseGroupNameFundingTypeFundingPeriodInfos(releaseGroupNames);

                var listOfReleaseGroupNameFundingTypeFundingPeriods = new StringBuilder();
                releaseGroupFundingTypeFundingPeriodInfos.ToList()
                    .ForEach(rgftfpi =>
                        listOfReleaseGroupNameFundingTypeFundingPeriods.AppendLine(
                            $"{rgftfpi.ReleaseGroupName}, {rgftfpi.FundingTypeCode}, {rgftfpi.FundingPeriodCode}"));

                var message = "The following ReleaseGroups(s) were not released due to in progress bulk import(s) " +
                              $"({EnvironmentHelper.GetEnvironmentSuffix(_appConfiguration)})" +
                              $"{Environment.NewLine} List of affected ReleaseGroupName, FundingType and FundingPeriods: " +
                              $"{Environment.NewLine} {listOfReleaseGroupNameFundingTypeFundingPeriods}";

                await _slackMessageSender.SendMessage(message, _logger, SlackChannel.CfsRead);
            }
        }
    }
}