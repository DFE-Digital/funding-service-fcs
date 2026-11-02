namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;
    using Newtonsoft.Json.Linq;

    public static class GraphTokenProvider
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private static readonly MemoryCache Cache = MemoryCache.Default;

        private static string Tenant { get { return ConfigurationManager.AppSettings["Sharepoint:Oauth:Tenant"]; } }
        private static string ClientId { get { return ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientId"]; } }
        private static string ClientSecret { get { return ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientSecret"]; } }
        private static string Scope
        {
            get
            {
                var s = ConfigurationManager.AppSettings["Graph:Scope"];
                return !string.IsNullOrWhiteSpace(s) ? s.Trim() : "https://graph.microsoft.com/.default";
            }
        }

        private static string CacheKey { get { return (ClientId ?? string.Empty) + "|" + (Scope ?? string.Empty); } }

        public static string GetAccessToken()
        {
            object cached = Cache.Get(CacheKey);
            if (cached is Lazy<string>) return ((Lazy<string>)cached).Value;

            var newLazy = new Lazy<string>(RequestAccessToken, true);
            var existingLazy = (Lazy<string>)Cache.AddOrGetExisting(CacheKey, newLazy, DateTimeOffset.UtcNow.AddMinutes(5)) ?? newLazy;
            return existingLazy.Value;
        }

        private static string RequestAccessToken()
        {
            if (string.IsNullOrWhiteSpace(Tenant) || string.IsNullOrWhiteSpace(ClientId) || string.IsNullOrWhiteSpace(ClientSecret))
                throw new ArgumentException("Tenant/ClientId/ClientSecret appSettings are required.");

            string tokenEndpoint = "https://login.microsoftonline.com/" + Tenant + "/oauth2/v2.0/token";

            var form = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string,string>("client_id",     ClientId),
                new KeyValuePair<string,string>("client_secret", ClientSecret),
                new KeyValuePair<string,string>("grant_type",    "client_credentials"),
                new KeyValuePair<string,string>("scope",         Scope)
            });

            using (var req = new HttpRequestMessage(HttpMethod.Post, tokenEndpoint))
            {
                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                req.Content = form;

                using (var resp = HttpClient.SendAsync(req).Result)
                {
                    string raw = resp.Content.ReadAsStringAsync().Result;
                    if (!resp.IsSuccessStatusCode)
                        throw new InvalidOperationException("AAD token error " + (int)resp.StatusCode + " " + resp.ReasonPhrase + ": " + raw);

                    var json = JObject.Parse(raw);
                    var token = (string)json["access_token"];
                    if (string.IsNullOrWhiteSpace(token))
                        throw new InvalidOperationException("Token response missing access_token");

                    int expiresInSec = json["expires_in"] != null ? (int)json["expires_in"] : 3600;
                    int buffer = Math.Min(60, Math.Max(10, expiresInSec / 20));
                    var absoluteExpiration = DateTimeOffset.UtcNow.AddSeconds(expiresInSec - buffer);

                    Cache.Set(CacheKey, new Lazy<string>(delegate { return token; }, true),
                              new CacheItemPolicy { AbsoluteExpiration = absoluteExpiration });

                    return token;
                }
            }
        }
    }
}
