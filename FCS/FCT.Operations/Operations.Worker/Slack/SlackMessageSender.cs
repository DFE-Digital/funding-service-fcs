namespace Operations.Worker.Slack
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using NServiceBus.Faults;
    using Extensions;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class SlackMessageSender : ISlackMessageSender
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private readonly IConfigurationRoot _appConfiguration;

        public SlackMessageSender(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        public async Task SendMessage(FailedMessage failed, ILogger logger)
        {
            var slackMessage = failed.ToErrorMessage(GetEnvironmentName());

            await SendMessage(slackMessage, logger);
        }

        public async Task SendMessage(string message, ILogger logger)
        {
            var formattedText = $"({GetEnvironmentName()}) " + message;
            await SendMessage(new SlackMessage(formattedText), logger);
        }

        private async Task SendMessage(SlackMessage message, ILogger logger)
        {
            try
            {
                HttpClient.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));

                string slackUrl = _appConfiguration["ErrorWebhook:Url:General"];

                var jsonSlackMessage = JsonConvert.SerializeObject(message);

                var stringContent = new StringContent(jsonSlackMessage, Encoding.UTF8, "application/json");

                await HttpClient.PostAsync(slackUrl, stringContent);
            }
            catch (Exception e)
            {
                logger.LogError(1, $"Error sending message to slack: {e.Message} trace: {e.StackTrace}");
            }
        }

        private string GetEnvironmentName()
        {
            string environmentName = _appConfiguration["StorageTableSuffix"];

            return environmentName.IsEmpty() ? "Live" : environmentName;
        }
    }
}