namespace SFA.FCT.CrossDomain.Integration.Azure.Worker.Slack
{
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Newtonsoft.Json;
    using NServiceBus.Faults;
    using Framework.Logging.Interfaces;

    public static class ErrorMessageNotifier
    {
        public static void SendMessge(FailedMessage failed, ILogger logger, string service)
        {
            try
            {
                using (var httpClient = new HttpClient())
                {
                    httpClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json"));

                    var slackMessage = failed.ToErrorMessage(GetEnvironmentName(), service: service);

                    string slackUrl = ConfigurationManager.AppSettings["ErrorWebhook:UrlXml"];

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

        private static string GetEnvironmentName()
        {
            var environmentName = ConfigurationManager.AppSettings["StorageTableSuffix"];

            return environmentName.IsEmpty() ? "Live" : environmentName;
        }

        private static bool IsEmpty(this string text)
        {
            return string.IsNullOrEmpty(text);
        }
    }
}
