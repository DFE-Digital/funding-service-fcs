namespace FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services
{
    using System.Threading.Tasks;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using Slack;

    public class CreateProvidersIfNecessaryNotificationService : ICreateProvidersIfNecessaryNotificationService
    {
        private readonly ISlackMessageSender _slackMessageSender;
        private readonly ILogger _logger;
        private readonly IConfigurationRoot _appConfiguration;

        public CreateProvidersIfNecessaryNotificationService(ISlackMessageSender slackMessageSender,
            ILogger logger,
            IConfigurationRoot appConfiguration)
        {
            _slackMessageSender = slackMessageSender;
            _logger = logger;
            _appConfiguration = appConfiguration;
        }

        public async Task NotifySlackRegardingProviderNotFoundChangedToConfigFailure(string fundingId)
        {
            var shouldSendToSlack = _appConfiguration["Slack:ShouldSend"];

            if (shouldSendToSlack == "true")
            {
                string message = $"FundingId: {fundingId} has changed from Provider Not Found to Config Failure ({EnvironmentHelper.GetEnvironmentSuffix(_appConfiguration)})";

                await _slackMessageSender.SendMessage(message, _logger, SlackChannel.CfsRead);
            }
        }
    }
}
