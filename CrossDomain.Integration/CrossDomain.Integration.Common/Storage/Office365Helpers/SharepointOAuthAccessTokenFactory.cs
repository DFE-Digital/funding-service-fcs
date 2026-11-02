
namespace SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers
{
    using Newtonsoft.Json.Linq;
    using Polly;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;

    public static class SharepointOAuthAccessTokenFactory
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private static readonly MemoryCache Cache = MemoryCache.Default;

        private static readonly string Tenant =
            ConfigurationManager.AppSettings["Sharepoint:Oauth:Tenant"];
        private static readonly string ClientId =
            ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientId"];
        private static readonly string ClientSecret =
            Environment.GetEnvironmentVariable("SP_CLIENT_SECRET") ??
            ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientSecret"];

        // Graph audience (allow override if you need)
        private static readonly string Scope =
            (ConfigurationManager.AppSettings["Graph:Scope"] ?? "https://graph.microsoft.com/.default").Trim();

        private static readonly string TokenEndpoint =
            "https://login.microsoftonline.com/" + Tenant + "/oauth2/v2.0/token";

        private static string CacheKey
        {
            get { return Tenant + "|" + ClientId + "|" + Scope; }
        }

        public static string GetAccessToken()
        {
            object cached = Cache.Get(CacheKey);
            if (cached is Lazy<string>)
            {
                return ((Lazy<string>)cached).Value;
            }

            var newLazy = new Lazy<string>(RequestAccessTokenWithRetry, true);
            object existing = Cache.AddOrGetExisting(CacheKey, newLazy, DateTimeOffset.UtcNow.AddMinutes(5));
            var winner = existing as Lazy<string> ?? newLazy;
            return winner.Value;
        }

        public static void ClearCache()
        {
            Cache.Remove(CacheKey);
        }

        private static string RequestAccessTokenWithRetry()
        {
            return Policy
                .Handle<Exception>(delegate { return true; })
                .WaitAndRetry(
                    retryCount: 5,
                    sleepDurationProvider: delegate (int attempt) { return TimeSpan.FromSeconds(2 * attempt); })
                .Execute(RequestAccessToken);
        }

        private static string RequestAccessToken()
        {
            var form = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id",     ClientId),
                new KeyValuePair<string, string>("client_secret", ClientSecret),
                new KeyValuePair<string, string>("grant_type",    "client_credentials"),
                new KeyValuePair<string, string>("scope",         Scope)
            });

            using (var req = new HttpRequestMessage(HttpMethod.Post, TokenEndpoint))
            {
                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                req.Content = form;

                using (var resp = HttpClient.SendAsync(req).Result)
                {
                    string raw = resp.Content.ReadAsStringAsync().Result;

                    if (!resp.IsSuccessStatusCode)
                    {
                        string authHeader = "<none>";
                        if (resp.Headers.Contains("WWW-Authenticate"))
                        {
                            authHeader = string.Join(" | ", resp.Headers.GetValues("WWW-Authenticate"));
                        }

                        throw new InvalidOperationException(
                            "AAD token request failed. HTTP " + (int)resp.StatusCode + " " + resp.ReasonPhrase +
                            ". Scope='" + Scope + "'. WWW-Authenticate: " + authHeader + ". Body: " + raw);
                    }

                    var json = JObject.Parse(raw);
                    var accessToken = (string)json["access_token"];
                    int expiresInSec = (int?)json["expires_in"] ?? 3600;

                    if (string.IsNullOrWhiteSpace(accessToken))
                        throw new InvalidOperationException("Token response missing 'access_token'.");

                    int buffer = Math.Min(60, Math.Max(10, expiresInSec / 20));
                    var absoluteExpiration = DateTimeOffset.UtcNow.AddSeconds(expiresInSec - buffer);

                    Cache.Set(
                        CacheKey,
                        new Lazy<string>(delegate { return accessToken; }, true),
                        new CacheItemPolicy { AbsoluteExpiration = absoluteExpiration });

                    return accessToken;
                }
            }
        }
    }
}
