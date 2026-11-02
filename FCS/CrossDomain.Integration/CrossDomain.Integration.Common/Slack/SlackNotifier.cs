namespace SFA.FCT.CrossDomain.Integration.Common.Slack
{
    using Framework.Logging.Interfaces;
    using Newtonsoft.Json;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Security.Policy;
    using System.Text;

    public class SlackNotifier
    {
        public static void SendMessage(string message, ILogger logger)
        {
            var shouldSendToSlack = ConfigurationManager.AppSettings["SlackError:ShouldSend"];
            
            if (shouldSendToSlack == "true")
            {                
                using (var httpClient = new HttpClient())
                {
                    httpClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json"));

                    var url = ConfigurationManager.AppSettings["ErrorWebhook:UrlXml"];
                    url = System.Net.WebUtility.HtmlDecode(url);

                    var jsonSlackMessage = JsonConvert.SerializeObject(new SlackMessage(message));

                    var stringContent = new StringContent(jsonSlackMessage, Encoding.UTF8, "application/json");

                    httpClient.PostAsync(url, stringContent).Wait();
                }
            }
        }
    }
}