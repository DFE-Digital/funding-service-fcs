namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Runtime.Caching;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactory : IBearerTokenFactory
    {
        private const string AadInstance = "https://login.microsoftonline.com/{0}";
        private const string Tenant = "fcsazuresfabisgov.onmicrosoft.com";

        private static readonly MemoryCache ObjectCache = MemoryCache.Default;


        public string GetAccessToken(string clientId, string appKey, string resourceId)
        {
            string key = $"{clientId}_{appKey}";
            var newLazyAccessToken = new Lazy<string>(() => RequestAccessTokenWithRetry(clientId, appKey, resourceId));

            var existingLazyAccessToken = (Lazy<string>)ObjectCache.AddOrGetExisting(
                key, newLazyAccessToken, DateTimeOffset.UtcNow.AddMinutes(57));

            return (existingLazyAccessToken ?? newLazyAccessToken).Value;
        }

        private static string RequestAccessTokenWithRetry(string clientId, string appKey, string resourceId)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => RequestAccessToken(clientId, appKey, resourceId));
        }

        private static string RequestAccessToken(string clientId, string appKey, string resourceId)
        {
            var authority = string.Format(AadInstance, Tenant);

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            var httpClient = new HttpClient();
            var response = httpClient.PostAsync(authority + "/oauth2/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }

    public interface IBearerTokenFactory
    {
        string GetAccessToken(string clientId, string appKey, string resourceId);
    }
}