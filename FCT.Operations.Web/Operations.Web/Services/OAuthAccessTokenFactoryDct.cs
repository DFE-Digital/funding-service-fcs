namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Runtime.Caching;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactoryDct : IOAuthAccessTokenFactoryDct
    {
        private const string AadInstance = "https://login.microsoftonline.com/{0}";

        private readonly MemoryCache _objectCache = MemoryCache.Default;

        public void ClearCache(string clientId)
        {
            _objectCache.Remove(clientId);
        }

        public string GetAccessToken(string clientId, string clientSecret, string scope, string tenant)
        {
            var newLazyAccessToken = new Lazy<string>(() => RequestAccessTokenWithRetry(clientId, clientSecret, scope, tenant));

            var existingLazyAccessToken = (Lazy<string>)_objectCache.AddOrGetExisting(
                clientId, newLazyAccessToken, DateTimeOffset.UtcNow.AddMinutes(56));

            return (existingLazyAccessToken ?? newLazyAccessToken).Value;
        }

        private static string RequestAccessTokenWithRetry(string clientId, string clientSecret, string scope, string tenant)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => RequestAccessToken(clientId, clientSecret, scope, tenant));
        }

        private static string RequestAccessToken(string clientId, string clientSecret, string scope, string tenant)
        {
            var authority = string.Format(AadInstance, tenant);

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("scope", scope),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", clientSecret),
            });

            var httpClient = new HttpClient();
            var response = httpClient.PostAsync(authority + "/oauth2/v2.0/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }
}