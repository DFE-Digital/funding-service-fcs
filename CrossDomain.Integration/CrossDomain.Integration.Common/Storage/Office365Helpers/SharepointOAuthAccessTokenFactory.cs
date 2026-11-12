namespace SFA.FCT.CrossDomain.Integration.Common.Storage.Office365Helpers
{
    using Microsoft.Online.SharePoint.TenantAdministration;
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
        private static HttpClient HttpClient = new HttpClient();
        private static MemoryCache Cache = MemoryCache.Default;

        //private static string Tenant => LoadConfiguration().AppSettings.Settings["Sharepoint:Oauth:Tenant"]?.Value;
        //private static string ClientId =>LoadConfiguration().AppSettings.Settings["Sharepoint:Oauth:ClientId"]?.Value;
        //private static string ClientSecret =>LoadConfiguration().AppSettings.Settings["Sharepoint:Oauth:ClientSecret"]?.Value;
        //private static string Scope =>LoadConfiguration().AppSettings.Settings["Graph:Scope"]?.Value ?? "https://graph.microsoft.com/.default";

        private static string Tenant =>CommonConfiguration.Configuration["Sharepoint:Oauth:Tenant"];

        private static string ClientId =>CommonConfiguration.Configuration["Sharepoint:Oauth:ClientId"];

        private static string ClientSecret =>CommonConfiguration.Configuration["Sharepoint:Oauth:ClientSecret"];
        private static string Scope => CommonConfiguration.Configuration["Graph:Scope"] ?? "https://graph.microsoft.com/.default";


        private static string TokenEndpoint ="https://login.microsoftonline.com/" + Tenant + "/oauth2/v2.0/token";

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

            Console.WriteLine("Tenant from AppSettings NOW = " + ConfigurationManager.AppSettings["Sharepoint:Oauth:Tenant"]);
            Console.WriteLine("ClientId from AppSettings NOW = " + ConfigurationManager.AppSettings["Sharepoint:Oauth:ClientId"]);

            using (var req = new HttpRequestMessage(HttpMethod.Post, TokenEndpoint))
            {
                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                req.Content = form;

                Console.WriteLine($"ClientId Length={ClientId?.Length}");
                Console.WriteLine($"Tenant='{Tenant}'");
                Console.WriteLine($"Secret Length={ClientSecret?.Length}");
                Console.WriteLine($"Scope='{Scope}'");
                Console.WriteLine($"TokenEndpoint='{TokenEndpoint}'");

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

                        Console.WriteLine(raw);

                        //throw new InvalidOperationException(
                        //    "AAD token request failed. HTTP " + (int)resp.StatusCode + " " + resp.ReasonPhrase +
                        //    ". Scope='" + Scope + "'. WWW-Authenticate: " + authHeader + ". Body: " + raw);
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

        //public static Configuration LoadConfiguration()
        //{
        //    var configFile = Path.Combine(
        //        AppContext.BaseDirectory,
        //        "TeamSiteTests.dll.config");

        //    var map = new ExeConfigurationFileMap
        //    {
        //        ExeConfigFilename = configFile
        //    };

        //    return ConfigurationManager.OpenMappedExeConfiguration(
        //        map,
        //        ConfigurationUserLevel.None);
        //}
    }
}
