
namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;
    using Newtonsoft.Json.Linq;
    using Polly;
    public static class SharepointOAuthAccessTokenFactory
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private static readonly MemoryCache Cache = MemoryCache.Default;

        // Configuration (legacy keys retained where possible)
        private static readonly string Tenant =
            ConfigurationManager.AppSettings["Sharepoint:Oauth:Tenant"];

        private static readonly string ClientId =
            ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientId"];

        // Prefer appSetting; fallback to env var for flexibility in CI/CD
        private static readonly string ClientSecret =
            !string.IsNullOrWhiteSpace(ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientSecret"])
                ? ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientSecret"]
                : Environment.GetEnvironmentVariable("SP_CLIENT_SECRET");
     
        private static readonly string Scope = ResolveScope();

        // Cache key unique per tenant + audience + client
        private static readonly string CacheKey =
            (Tenant ?? string.Empty) + "|" + (ClientId ?? string.Empty) + "|" + (Scope ?? string.Empty);

        /// <summary>
        /// Returns a cached app-only access token for Microsoft Graph.
        /// </summary>
        public static string GetAccessToken()
        {
            object cached = Cache.Get(CacheKey);
            if (cached is Lazy<string>)
            {
                return ((Lazy<string>)cached).Value;
            }

            var newLazy = new Lazy<string>(RequestAccessTokenWithRetry, true);

            var existingLazy =
                (Lazy<string>)Cache.AddOrGetExisting(
                    CacheKey,
                    newLazy,
                    DateTimeOffset.UtcNow.AddMinutes(5) // temporary TTL, replaced with precise expiry after issuance
                ) ?? newLazy;

            return existingLazy.Value;
        }

        /// <summary>
        /// Clears the cached token (forces re-acquisition next call).
        /// </summary>
        public static void ClearCache()
        {
            Cache.Remove(CacheKey);
        }

        private static string RequestAccessTokenWithRetry()
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(
                    retryCount: 5,
                    sleepDurationProvider: attempt => TimeSpan.FromSeconds(2 * attempt) // 2s,4s,6s,8s,10s
                )
                .Execute(RequestAccessToken);
        }

        private static string RequestAccessToken()
        {
            if (string.IsNullOrWhiteSpace(Tenant))
                throw new ArgumentException("AppSetting 'Sharepoint:Oauth:Tenant' is missing.");
            if (string.IsNullOrWhiteSpace(ClientId))
                throw new ArgumentException("AppSetting 'Sharepoint:Oauth:ClientId' is missing.");
            if (string.IsNullOrWhiteSpace(ClientSecret))
                throw new ArgumentException("Client secret is missing (checked 'Sharepoint:Oauth:ClientSecret' and env 'SP_CLIENT_SECRET').");
            if (string.IsNullOrWhiteSpace(Scope))
                throw new ArgumentException("Scope could not be resolved (expected Graph:Scope or default).");

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

                        // Include endpoint/scope in error for faster diagnostics.
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

                    // Cache the token for its lifetime minus a small safety buffer (~5%)
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
        private static string ResolveScope()
        {
            string configured = ConfigurationManager.AppSettings["Graph:Scope"];
            if (!string.IsNullOrWhiteSpace(configured))
            {
                return configured.Trim();
            }

            return "https://graph.microsoft.com/.default";
        }
    }
}
