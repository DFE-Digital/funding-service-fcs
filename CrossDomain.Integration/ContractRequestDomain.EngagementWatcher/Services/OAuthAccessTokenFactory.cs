namespace ContractRequestDomain.EngagementWatcher.Services
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Runtime.Caching;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactory : IOAuthAccessTokenFactory
    {
        private const string AccessTokenCacheKey = "DAS_ENGAGEMENTS_OAUTH_ACCESS_TOKEN";
        private const string AadInstance = "https://login.microsoftonline.com/{0}";
        private const string Tenant = "fcsazuresfabisgov.onmicrosoft.com";

        private readonly MemoryCache _objectCache = MemoryCache.Default;
        private readonly Func<string, string, string, string> _requestAccessToken;

        public OAuthAccessTokenFactory()
            : this(RequestAccessToken)
        {
        }

        public OAuthAccessTokenFactory(Func<string, string, string, string> requestAccessToken)
        {
            _requestAccessToken = requestAccessToken ?? throw new ArgumentNullException(nameof(requestAccessToken));
        }

        public void ClearCache()
        {
            _objectCache.Remove(AccessTokenCacheKey);
        }

        public string GetAccessToken(string clientId, string appKey, string resourceId)
        {
            var newLazyAccessToken = new Lazy<string>(() => RequestAccessTokenWithRetry(clientId, appKey, resourceId));

            var existingLazyAccessToken = (Lazy<string>)_objectCache.AddOrGetExisting(
                AccessTokenCacheKey, newLazyAccessToken, DateTimeOffset.UtcNow.AddMinutes(56));

            return (existingLazyAccessToken ?? newLazyAccessToken).Value;
        }

        private string RequestAccessTokenWithRetry(string clientId, string appKey, string resourceId)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => _requestAccessToken(clientId, appKey, resourceId));
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
}