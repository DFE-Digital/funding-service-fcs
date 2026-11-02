namespace PerformanceManagementDomain.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Runtime.Caching;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactory : IOAuthAccessTokenFactory
    {
        private readonly MemoryCache _objectCache = MemoryCache.Default;

        public void ClearCache(string clientId)
        {
            _objectCache.Remove(clientId);
        }

        public string GetAccessToken(string clientId, string clientSecret, string scope, string tenant)
        {
            Lazy<string> newLazyAccessToken = new Lazy<string>(() => RequestAccessTokenWithRetry(clientId, clientSecret, scope, tenant));

            Lazy<string> existingLazyAccessToken = (Lazy<string>)_objectCache.AddOrGetExisting(
                clientId, newLazyAccessToken, DateTimeOffset.UtcNow.AddMinutes(56));

            return (existingLazyAccessToken ?? newLazyAccessToken).Value;
        }

        private static string RequestAccessTokenWithRetry(string clientId, string appKey, string scope, string tenant)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => RequestAccessToken(clientId, appKey, scope, tenant));
        }

        private static string RequestAccessToken(string clientId, string appKey, string scope, string tenant)
        {
            FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("scope", scope),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            HttpClient httpClient = new HttpClient();
            HttpResponseMessage response = httpClient.PostAsync($"https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }
}
