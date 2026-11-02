namespace FundingAllocation.Endpoints.CheckForReadComplete
{
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Services;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;

    public class CheckForReadCompleteNotificationService : ICheckForReadCompleteNotificationService
    {
        private readonly ISlackMessageSender _slackMessageSender;
        private readonly ICheckForReadCompleteFundingAllocationRepository _fundingAllocationRepository;
        private readonly ILogger _logger;
        private readonly IConfigurationRoot _appConfiguration;

        public CheckForReadCompleteNotificationService(ISlackMessageSender slackMessageSender, ICheckForReadCompleteFundingAllocationRepository fundingAllocationRepository, ILogger logger, IConfigurationRoot appConfiguration)
        {
            _slackMessageSender = slackMessageSender;
            _fundingAllocationRepository = fundingAllocationRepository;
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public async Task NotifySlackRegardingParkedFundingAllocations(int readId)
        {
            var shouldSendToSlack = _appConfiguration["Slack:ShouldSend"];

            if (shouldSendToSlack == "true")
            {
                var numParkedNotAwaitingOutcome = await _fundingAllocationRepository.GetNumParkedNotAwaitingOutcome(readId);

                if (numParkedNotAwaitingOutcome > 0)
                {
                    string message = $"Number Parked That Are Not Awaiting Outcome: {numParkedNotAwaitingOutcome} ({EnvironmentHelper.GetEnvironmentSuffix(_appConfiguration)})";

                    await _slackMessageSender.SendMessage(message, _logger, SlackChannel.CfsRead);
                }
            }
        }
    }
}
