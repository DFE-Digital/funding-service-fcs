namespace SFA.FCS.Worker.Common.Slack
{
    using FCT.Framework.Logging.Interfaces;
    using NServiceBus.Faults;
    using System;
    using System.Configuration;
    using System.Net.Http;
    using System.Text;
    using Newtonsoft.Json;

    public static class ErrorMessageNotifier
    {
        private static string url = ConfigurationManager.AppSettings["ErrorWebhook:UrlXml"];

        public static void SendMessage(FailedMessage failed, ILogger logger, string service)
        {
            try
            {
                url = System.Net.WebUtility.HtmlDecode(url);
                var errorMessage = failed.ToErrorMessage(GetEnvironmentName(), service);
                PostMessage(url, errorMessage);
            }
            catch (Exception e)
            {
                logger.LogError(1, $"Error sending message : {e.Message} trace: {e.StackTrace}");
            }
        }

        public static void SendMessage(string message, ILogger logger, string service)
        {
            try
            {
                url = System.Net.WebUtility.HtmlDecode(url);
                var errorMessage = new ErrorMessage(service, $"({GetEnvironmentName()}) {message}");                
                PostMessage(url, errorMessage);
            }
            catch (Exception e)
            {
                logger.LogError(1, $"Error sending message: {e.Message} trace: {e.StackTrace}");
            }
        }

        private static void PostMessage(string url, ErrorMessage message)
        {
            using (var httpClient = new HttpClient())
            {
                var jsonMessage = JsonConvert.SerializeObject(message);
                var stringContent = new StringContent(jsonMessage, Encoding.UTF8, "application/json");

                httpClient.PostAsync(url, stringContent).Wait();
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
