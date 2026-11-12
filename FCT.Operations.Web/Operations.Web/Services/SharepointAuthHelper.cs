namespace Operations.Web.Services
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net.Http;
    using Microsoft.SharePoint.Client;
    using Newtonsoft.Json;

    public static class SharepointAuthHelper
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private static string Url => ConfigurationManager.AppSettings["ida:Resource"];

        public static ClientContext GetOAuthContext()
        {
            ClientContext context = new ClientContext(Url);
            context.ExecutingWebRequest += (sender, e) => e.WebRequestExecutor.RequestHeaders["Authorization"] = $"Bearer {GetAccessToken()}";

            return context;
        }

        private static string GetAccessToken()
        {
            var urlItems = Url.Split('/');
            string tenant = ConfigurationManager.AppSettings["Sharepoint:Oauth:Tenant"];
            string clientId = ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientId"] + "@" + tenant;
            string clientSecret = ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientSecret"];
            string sharepointUrl = urlItems[2];
            string sharepointPrinciple = ConfigurationManager.AppSettings["Sharepoint:Oauth:Principle"];

            string resource = $"{sharepointPrinciple}/{sharepointUrl}@{tenant}";

            FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("client_secret", clientSecret),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("resource", resource)
            });

            
            HttpResponseMessage response = HttpClient.PostAsync($"https://accounts.accesscontrol.windows.net/{tenant}/tokens/OAuth/2", formContent).Result;


            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }
}