namespace ContractManagementService.Services
{
    using System;
    using System.Collections.Generic;
    using Microsoft.Extensions.Caching.Memory;
    using Newtonsoft.Json;
    using System.Net.Http;
    using Polly;
    using SFA.FCS.Worker.Common;

    public static class CrmAccessTokenFactory
    {
        private static readonly MemoryCache _cache = new MemoryCache(new MemoryCacheOptions());
        private static readonly HttpClient HttpClient = new HttpClient();
        private const string AccessTokenCacheKey = "DYNAMICS_365_OAUTH_ACCESS_TOKEN";
        private const int AccessTokenCacheExpirationMinutes = 55;

        public static string GetAccessToken(IFcsConfiguration appConfiguration)
        {
            if (!_cache.TryGetValue(AccessTokenCacheKey, out string existingAccessToken))
            {
                var newAccessToken = GetAccessTokenWithRetry(appConfiguration);

                var cacheEntryOptions = new MemoryCacheEntryOptions();
                cacheEntryOptions.AbsoluteExpirationRelativeToNow = new TimeSpan(0, 0, AccessTokenCacheExpirationMinutes, 0);

                _cache.Set(AccessTokenCacheKey, newAccessToken, cacheEntryOptions);

                return newAccessToken;
            }

            return existingAccessToken;
        }

        private static string GetAccessTokenWithRetry(IFcsConfiguration appConfiguration)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => GetAccessTokenFromClaimsProvider(appConfiguration));
        }

        public static string GetAccessTokenFromClaimsProvider(IFcsConfiguration appConfiguration)
        {
            var aadInstance = appConfiguration["CRM:AADInstance"];
            var tenant = appConfiguration["CRM:Tenant"];
            var clientId = appConfiguration["CRM:ClientId"];
            var appKey = appConfiguration["CRM:AppKey"];
            var resourceId = appConfiguration["CRM:ResourceId"];

            string authority = string.Format(aadInstance, tenant);

            FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            var response = HttpClient.PostAsync(authority + "/oauth2/token", formContent).Result;

            response.EnsureSuccessStatusCode();

            dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jsonObject.access_token;
        }
    }
}
