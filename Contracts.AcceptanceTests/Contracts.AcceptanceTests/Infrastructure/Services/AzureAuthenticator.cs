namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Security.Authentication;
    using System.Threading;
    using DTO;
    using Microsoft.IdentityModel.Clients.ActiveDirectory;
    using Newtonsoft.Json;

    public static class AzureAuthenticator
    {
        public static AzureAuthenticationConfig GetAuthenticationConfig()
        {
            return new AzureAuthenticationConfig
            {
                AadInstance = ConfigurationManager.AppSettings["ida:AADInstance_ContractPublish"],
                Tenant = ConfigurationManager.AppSettings["ida:Tenant_ContractPublish"],
                ClientId = ConfigurationManager.AppSettings["ida:ClientId_ContractPublish"],
                AppKey = ConfigurationManager.AppSettings["ida:AppKey_ContractPublish"],
                ResourceId = ConfigurationManager.AppSettings["ida:ResourceId_ContractPublish"]
            };
        }

        public static string GetAuthenticationResult()
        {
            return GetAuthenticationResult(new AzureAuthenticationConfig
            {
                AadInstance = ConfigurationManager.AppSettings["ida:AADInstance_ContractPublish"],
                Tenant = ConfigurationManager.AppSettings["ida:Tenant_ContractPublish"],
                ClientId = ConfigurationManager.AppSettings["ida:ClientId_ContractPublish"],
                AppKey = ConfigurationManager.AppSettings["ida:AppKey_ContractPublish"],
                ResourceId = ConfigurationManager.AppSettings["ida:ResourceId_ContractPublish"]
            });
        }

        public static string GetAuthenticationResult(AzureAuthenticationConfig config)
        {
            // string authority = string.Format(CultureInfo.InvariantCulture, config.AadInstance, config.Tenant);
            
            string authority = string.Format(config.AadInstance, config.Tenant);
            int retryCount = 0;
            FormUrlEncodedContent formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", config.ClientId),
                new KeyValuePair<string, string>("resource", config.ResourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", config.AppKey),
            });

            do
            {
                try
                {
                    using (HttpClient httpClient = new HttpClient())
                    {
                        httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
                        string json = httpClient.PostAsync(authority + "/oauth2/token", formContent).Result.Content.ReadAsStringAsync().Result;
                        dynamic jsonObject = JsonConvert.DeserializeObject(json);

                        return jsonObject.access_token;
                    }
                }
                catch (Exception)
                {
                    retryCount++;
                    Thread.Sleep(3000);
                }
            }
            while (retryCount < 3);

            throw new AuthenticationException("Could not authenticate with the OAUTH2 claims provider after several attempts");
        }

        public static string GetAuthenticationResult(string appSettingsSuffix)
        {
            string aadInstance = ConfigurationManager.AppSettings[$"ida:AADInstance_{appSettingsSuffix}"];
            string tenant = ConfigurationManager.AppSettings[$"ida:Tenant_{appSettingsSuffix}"];
            string clientId = ConfigurationManager.AppSettings[$"ida:ClientId_{appSettingsSuffix}"];
            string appKey = ConfigurationManager.AppSettings[$"ida:AppKey_{appSettingsSuffix}"];
            string resourceId = ConfigurationManager.AppSettings[$"ida:ResourceId_{appSettingsSuffix}"];

            string authority = string.Format(aadInstance, tenant);

            int retryCount = 0;
            bool retry;

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resourceId),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", appKey),
            });

            do
            {
                try
                {
                    using (var httpClient = new HttpClient())
                    {
                        httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
                        var json = httpClient.PostAsync(authority + "/oauth2/token", formContent).Result.Content.ReadAsStringAsync().Result;
                        dynamic jsonObject = JsonConvert.DeserializeObject(json);

                        return jsonObject.access_token;
                    }
                }
                catch (Exception)
                {
                    retry = true; // todo: refactor this
                    retryCount++;
                    Thread.Sleep(3000);
                }
            }
            while (retry && (retryCount < 3));

            throw new AuthenticationException("Could not authenticate with the OAUTH2 claims provider after several attempts");
        }
    }
}