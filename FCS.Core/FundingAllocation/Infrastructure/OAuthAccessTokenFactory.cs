namespace FundingAllocation.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using Microsoft.Extensions.Caching.Memory;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactory
    {
        private static readonly MemoryCache Cache = new MemoryCache(new MemoryCacheOptions());
        private static readonly HttpClient HttpClient = new HttpClient();
        private const int AccessTokenCacheExpirationMinutes = 55;

        public enum SecureApplication
        {
            Cfs
        };

        public static string GetAccessToken(IConfiguration appConfiguration, SecureApplication secureApplication)
        {
            if (!Cache.TryGetValue(secureApplication.ToString(), out string existingAccessToken))
            {
                var newAccessToken = GetAccessTokenWithRetry(appConfiguration, secureApplication);

                var cacheEntryOptions = new MemoryCacheEntryOptions();
                cacheEntryOptions.AbsoluteExpirationRelativeToNow = new TimeSpan(0, 0, AccessTokenCacheExpirationMinutes, 0);

                Cache.Set(secureApplication.ToString(), newAccessToken, cacheEntryOptions);

                return newAccessToken;
            }

            return existingAccessToken;
        }

        private static string GetAccessTokenWithRetry(IConfiguration appConfiguration, SecureApplication secureApplication)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => GetAccessTokenFromClaimsProvider(appConfiguration, secureApplication));
        }

        public static string GetAccessTokenFromClaimsProvider(IConfiguration appConfiguration, SecureApplication secureApplication)
        {
            string applicationName = secureApplication.ToString().ToUpper();
            var aadInstance = appConfiguration[$"{applicationName}:AADInstance"];
            var tenant = appConfiguration[$"{applicationName}:Tenant"];
            var clientId = appConfiguration[$"{applicationName}:ClientId"];
            var clientSecret = appConfiguration[$"{applicationName}:ClientSecret"];
            var scope = appConfiguration[$"{applicationName}:Scope"];

            string authority = string.Format(aadInstance, tenant);

            FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("scope", scope),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", clientSecret),
            });

            var response = HttpClient.PostAsync(authority + "/oauth2/v2.0/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }
}
