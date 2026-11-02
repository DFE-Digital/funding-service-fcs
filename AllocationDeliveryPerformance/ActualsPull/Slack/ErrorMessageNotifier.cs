namespace ActualsPull.Slack
{
    using System;
    using System.Text;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using AllocationDeliveryPerformance;
    using Newtonsoft.Json;
    using NServiceBus.Faults;
    using SFA.FCT.Framework.Logging.Interfaces;

    public static class ErrorMessageNotifier
    {
        public static void SendMessge(FailedMessage failed, ILogger logger)
        {
            try
            {
                using (var httpClient = new HttpClient())
                {
                    httpClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json"));

                    var slackMessage = failed.ToErrorMessage();

                    string slackUrl = Config.GetAppSetting("SlackError:Url");

                    var jsonSlackMessage = JsonConvert.SerializeObject(slackMessage);

                    var stringContent = new StringContent(jsonSlackMessage, Encoding.UTF8, "application/json");

                    httpClient.PostAsync(slackUrl, stringContent).Wait();
                }
            }
            catch (Exception e)
            {
                logger.LogError(1, $"Error sending message to slack: {e.Message} trace: {e.StackTrace}");
            }
        }
    }
}
