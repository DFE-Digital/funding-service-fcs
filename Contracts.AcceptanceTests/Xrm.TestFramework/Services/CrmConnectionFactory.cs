namespace SFA.FCT.Xrm.TestFramework.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Runtime.Caching;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.WebServiceClient;
    using Newtonsoft.Json;
    using Polly;

    public static class CrmConnectionFactory
    {
        private static readonly IDictionary<string, string> UserToCrmUserDictionary = new Dictionary<string, string>
        {
            {
                "FCS2 Test", "FCS2 TEST"
            },
            {
                "FCS1 Test", "FCS1 TEST"
            }
        };

        public static IOrganizationService GetConnection()
        {
            return OAuthCrmConnectionFactory.GetOrganizationService();
        }

        public static IOrganizationService GetConnectionForSpecificUser(string userName)
        {
            string crmUser = null;
            if (UserToCrmUserDictionary.ContainsKey(userName))
            {
                crmUser = UserToCrmUserDictionary[userName];
            }
            else if (UserToCrmUserDictionary.Values.Contains(userName))
            {
                crmUser = userName;
            }

            var connection = OAuthCrmConnectionFactory.GetOrganizationService();

            connection.CallerId = GetUserId(userName, connection);

            return connection;
        }

        private static Guid GetUserId(string userName, IOrganizationService orgService)
        {
            using (var xrmContext = new XrmServiceContext(orgService))
            {
                return xrmContext.SystemUserSet.First(u => u.FullName == userName).Id;
            }
        }

        private static class OAuthCrmConnectionFactory
        {
            private const string AccessTokenCacheKey = "DYNAMICS_365_OAUTH_ACCESS_TOKEN";
            private const int AccessTokenCacheExpirationMinutes = 55;

            private static readonly HttpClient _httpClient;
            private static readonly MemoryCache _objectCache = MemoryCache.Default;
            private static Func<string, string> _appSettingReader;

            static OAuthCrmConnectionFactory()
            {
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                _httpClient = new HttpClient();
                _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
            }

            public static OrganizationWebProxyClient GetOrganizationService()
            {
                Uri baseUri = new Uri(GetAppSetting("ida:ResourceId_CrmOnline"));
                Uri serviceUri = new Uri(baseUri, @"xrmservices/2011/organization.svc/web?SdkClientVersion=8.2");

                Lazy<string> newLazyAccessToken = new Lazy<string>(GetAccessTokenWithRetry);

                Lazy<string> existingLazyAccessToken = (Lazy<string>)_objectCache.AddOrGetExisting(
                    AccessTokenCacheKey,
                    newLazyAccessToken,
                    new CacheItemPolicy { AbsoluteExpiration = DateTimeOffset.UtcNow.AddMinutes(AccessTokenCacheExpirationMinutes) });

                return new OrganizationWebProxyClient(serviceUri, true)
                {
                    HeaderToken = (existingLazyAccessToken ?? newLazyAccessToken).Value
                };
            }

            private static string GetAccessTokenWithRetry()
            {
                return Policy
                    .Handle<Exception>(_ => true)
                    .WaitAndRetry(3, _ => TimeSpan.FromSeconds(3))
                    .Execute(GetAccessToken);
            }

            private static string GetAccessToken()
            {
                string aadInstance = GetAppSetting("ida:AADInstance_CrmOnline");
                string tenant = GetAppSetting("ida:Tenant_CrmOnline");
                string clientId = GetAppSetting("ida:ClientId_CrmOnline");
                string appKey = GetAppSetting("ida:AppKey_CrmOnline");
                string resourceId = GetAppSetting("ida:ResourceId_CrmOnline");

                string authority = string.Format(aadInstance, tenant);

                FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
                {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

                HttpResponseMessage response = _httpClient.PostAsync(authority + "/oauth2/token", formContent).Result;
                response.EnsureSuccessStatusCode();

                dynamic jsonObject = JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return jsonObject.access_token;
            }

            private static string GetAppSetting(string key)
            {
                return _appSettingReader?.Invoke(key) ?? ConfigurationManager.AppSettings[key];
            }

            public static void SetAppSettingReader(Func<string, string> appSettingReader)
            {
                _appSettingReader = appSettingReader;
            }
        }

        public static void SetAppSettingReader(Func<string, string> appSettingReader)
        {
            OAuthCrmConnectionFactory.SetAppSettingReader(appSettingReader);
        }
    }
}

