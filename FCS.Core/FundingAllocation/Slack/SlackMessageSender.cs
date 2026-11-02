namespace FundingAllocation.Slack
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using Extensions;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using NServiceBus.Faults;
    using SFA.FCT.Framework.Logging.Interfaces;

    public enum SlackChannel
    {
        General,
        CfsRead
    }

    public class SlackMessageSender : ISlackMessageSender
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private readonly IConfigurationRoot _appConfiguration;

        public SlackMessageSender(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        public async Task SendMessage(FailedMessage failed, ILogger logger, SlackChannel slackChannel)
        {
            var slackMessage = failed.ToErrorMessage(GetEnvironmentName());

            await SendMessage(slackMessage, logger, slackChannel);
        }

        public async Task SendMessage(string message, ILogger logger, SlackChannel slackChannel)
        {
            await SendMessage(new SlackMessage(message), logger, slackChannel);
        }

        private async Task SendMessage(SlackMessage message, ILogger logger, SlackChannel slackChannel)
        {
            try
            {
                HttpClient.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                string slackUrl = GetSlackChannelUrl(slackChannel);

                var jsonSlackMessage = JsonConvert.SerializeObject(message);

                var stringContent = new StringContent(jsonSlackMessage, Encoding.UTF8, "application/json");

                await HttpClient.PostAsync(slackUrl, stringContent);
            }
            catch (Exception e)
            {
                logger.LogError(1, $"Error sending message to slack: {e.Message} trace: {e.StackTrace}");
            }
        }

        private string GetSlackChannelUrl(SlackChannel errorWebhookChannel)
        {
            if (errorWebhookChannel == SlackChannel.General)
            {
                return _appConfiguration["ErrorWebhook:Url:General"];
            }
            if (errorWebhookChannel == SlackChannel.CfsRead)
            {
                return _appConfiguration["ErrorWebhook:Url:Cfs_Read"];
            }
           
            throw new ArgumentException($"We don't support this slackChannel: {errorWebhookChannel}");
        }

        private string GetEnvironmentName()
        {
            string environmentName = _appConfiguration["StorageTableSuffix"];

            return environmentName.IsEmpty() ? "Live" : environmentName;
        }
    }
}
