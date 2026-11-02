namespace Operations.Web.Factory
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Configuration;
    using Newtonsoft.Json;
    using Polly;

    public class OAuthAccessTokenFactoryNoCache
    {
        private static readonly HttpClient HttpClient = new HttpClient();

        public enum SecureApplication
        {
            Cfs
        };

        public static string GetAccessToken(SecureApplication secureApplication)
        {
            return GetAccessTokenWithRetry(secureApplication);
        }

        private static string GetAccessTokenWithRetry(SecureApplication secureApplication)
        {
            return Policy
                .Handle<Exception>(_ => true)
                .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                .Execute(() => GetAccessTokenFromClaimsProvider(secureApplication));
        }

        public static string GetAccessTokenFromClaimsProvider(SecureApplication secureApplication)
        {
            string applicationName = secureApplication.ToString().ToUpper();

            var aadInstance = ConfigurationManager.AppSettings[$"{applicationName}:AADInstance"];
            var tenant = ConfigurationManager.AppSettings[$"{applicationName}:Tenant"];
            var clientId = ConfigurationManager.AppSettings[$"{applicationName}:ClientId"];
            var clientSecret = ConfigurationManager.AppSettings[$"{applicationName}:ClientSecret"];
            var scope = ConfigurationManager.AppSettings[$"{applicationName}:Scope"];

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