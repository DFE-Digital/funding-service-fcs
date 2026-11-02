
namespace FCT.Operations.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;
    using Newtonsoft.Json.Linq;
    using Polly;
    using SFA.FCS.Worker.Common;

    public class SharepointOAuthAccessTokenFactory : ISharepointOAuthAccessTokenFactory
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private static readonly MemoryCache Cache = MemoryCache.Default;

        private readonly string Tenant;       // e.g., contoso.onmicrosoft.com or tenant GUID
        private readonly string ClientId;
        private readonly string ClientSecret;
        private readonly string Scope;        // e.g., https://graph.microsoft.com/.default

        // Unique key per tenant + client + audience
        private string CacheKey
        {
            get { return (Tenant ?? "") + "|" + (ClientId ?? "") + "|" + (Scope ?? ""); }
        }

        public SharepointOAuthAccessTokenFactory(IFcsConfiguration configurationRoot)
        {
            if (configurationRoot == null) throw new ArgumentNullException("configurationRoot");

            // Read required config (reusing your existing keys)
            string secretFromConfig = configurationRoot["Sharepoint:Oauth:ClientSecret"];
            string secretFromEnv = Environment.GetEnvironmentVariable("SP_CLIENT_SECRET");

            ClientSecret = !string.IsNullOrWhiteSpace(secretFromConfig) ? secretFromConfig : secretFromEnv;
            ClientId = configurationRoot["Sharepoint:Oauth:ClientId"];
            Tenant = configurationRoot["Sharepoint:Oauth:Tenant"];

            // Optional override for audience; default to Graph /.default
            // You can set Graph:Scope = https://graph.microsoft.com/.default
            string configuredScope = configurationRoot["Graph:Scope"];
            Scope = !string.IsNullOrWhiteSpace(configuredScope)
                ? configuredScope.Trim()
                : "https://graph.microsoft.com/.default";

            // Basic validation
            if (string.IsNullOrWhiteSpace(ClientId))
                throw new ArgumentException("Sharepoint:Oauth:ClientId is missing.");
            if (string.IsNullOrWhiteSpace(ClientSecret))
                throw new ArgumentException("Sharepoint:Oauth:ClientSecret is missing (also checked env SP_CLIENT_SECRET).");
            if (string.IsNullOrWhiteSpace(Tenant))
                throw new ArgumentException("Sharepoint:Oauth:Tenant is missing.");
        }

        /// <summary>
        /// Returns a cached app-only access token for Microsoft Graph.
        /// </summary>
        public string GetAccessToken()
        {
            object cached = Cache.Get(CacheKey);
            if (cached is Lazy<string>)
            {
                return ((Lazy<string>)cached).Value;
            }

            // Coalesce concurrent callers
            var newLazy = new Lazy<string>(RequestAccessTokenWithRetry, true);

            var existingLazy =
                (Lazy<string>)Cache.AddOrGetExisting(
                    CacheKey,
                    newLazy,
                    DateTimeOffset.UtcNow.AddMinutes(5) // temporary TTL; replaced with real expiry after issuance
                ) ?? newLazy;

            return existingLazy.Value;
        }
        public void ClearCache()
        {
            Cache.Remove(CacheKey);
        }

        private string RequestAccessTokenWithRetry()
        {
            // Use 3-parameter onRetry to avoid Polly overload ambiguity in v7
            return Policy
                .Handle<Exception>(delegate { return true; })
                .WaitAndRetry(
                    retryCount: 5,
                    sleepDurationProvider: delegate (int attempt) { return TimeSpan.FromSeconds(2 * attempt); }, // 2s,4s,6s,8s,10s
                    onRetry: delegate (Exception ex, TimeSpan ts, Context ctx)
                    {
                        // Clear cached token so next attempt re-requests from AAD
                        Cache.Remove(CacheKey);
                    })
                .Execute(RequestAccessToken);
        }

        private string RequestAccessToken()
        {
            // v2.0 endpoint
            string tokenEndpoint = "https://login.microsoftonline.com/" + Tenant + "/oauth2/v2.0/token";

            var form = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string,string>("client_id",     ClientId),
                new KeyValuePair<string,string>("client_secret", ClientSecret),
                new KeyValuePair<string,string>("grant_type",    "client_credentials"),
                new KeyValuePair<string,string>("scope",         Scope) // MUST be *.default for client credentials
            });

            using (var req = new HttpRequestMessage(HttpMethod.Post, tokenEndpoint))
            {
                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                req.Content = form;

                using (var resp = HttpClient.SendAsync(req).Result)
                {
                    string raw = resp.Content.ReadAsStringAsync().Result;

                    if (!resp.IsSuccessStatusCode)
                    {
                        int status = (int)resp.StatusCode;
                        string reason = resp.ReasonPhrase;

                        string authHeader = "<none>";
                        if (resp.Headers.Contains("WWW-Authenticate"))
                        {
                            authHeader = string.Join(" | ", resp.Headers.GetValues("WWW-Authenticate"));
                        }

                        throw new InvalidOperationException(
                            "AAD token request failed. HTTP " + status + " " + reason +
                            ". Endpoint='" + tokenEndpoint + "'. Scope='" + Scope + "'. " +
                            "WWW-Authenticate: " + authHeader + ". Body: " + raw
                        );
                    }

                    JObject json = JObject.Parse(raw);
                    string accessToken = (string)json["access_token"];
                    int expiresInSec = json["expires_in"] != null ? (int)json["expires_in"] : 3600;

                    if (string.IsNullOrWhiteSpace(accessToken))
                        throw new InvalidOperationException("Token response missing 'access_token'.");

                    // Cache token for its lifetime minus a small safety buffer (~5%)
                    int buffer = expiresInSec / 20;
                    if (buffer < 10) buffer = 10;
                    if (buffer > 60) buffer = 60;

                    DateTimeOffset absoluteExpiration = DateTimeOffset.UtcNow.AddSeconds(expiresInSec - buffer);

                    Cache.Set(
                        CacheKey,
                        new Lazy<string>(delegate { return accessToken; }, true),
                        new CacheItemPolicy { AbsoluteExpiration = absoluteExpiration }
                    );

                    return accessToken;
                }
            }
        }
    }
}
