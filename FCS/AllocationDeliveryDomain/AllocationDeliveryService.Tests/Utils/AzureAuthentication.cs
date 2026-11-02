namespace SFA.FCT.ContractManagementService.Test.Utils
{
    using Newtonsoft.Json;
    using System.Collections.Generic;
    using System.Net.Http;
    using AllocationDeliveryService.Tests;
    using FCS.Worker.Common;

    public static class AzureAuthentication
    {
        private static IFcsConfiguration _configuration;
        private static readonly string AadInstance = GetConfiguration()["ida:AADInstance"];
        private static readonly string Tenant = GetConfiguration()["ida:Tenant"];
        private static readonly string ClientId = GetConfiguration()["ida:ClientId"];
        private static readonly string AppKey = GetConfiguration()["ida:AppKey"];
        private static readonly string ResourceId = GetConfiguration()["ida:ResourceId"];


        public static string GetAuthenticationResult()
        {
            return RequestAccessToken(ClientId, AppKey, ResourceId, Tenant);
        }

        private static string RequestAccessToken(string clientId, string appKey, string resource, string tenant)
        {
            var authority = string.Format(AadInstance, tenant);

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resource),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            var httpClient = new HttpClient();
            var response = httpClient.PostAsync(authority + "/oauth2/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }

        private static IFcsConfiguration GetConfiguration()
        {
            return _configuration ??= new AppConfiguration();
        }
    }
}
