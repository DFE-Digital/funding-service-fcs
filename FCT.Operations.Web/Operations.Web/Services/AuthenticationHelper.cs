namespace Operations.Web.Services
{
    using System;
    using System.Collections.Generic;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Security.Authentication;
    using System.Threading;
    using Dtos;
    using Newtonsoft.Json;

    public class AuthenticationHelper : IAuthenticationHelper
    {
        public string GetAuthenticationResult(AuthenticationRequest authReq)
        {
           string token = GetToken(authReq.AdInstance, authReq.Tenant, authReq.ClientId, authReq.AppKey, authReq.ResourceId);

            return token;
        }

        public static string GetToken(string claimsProviderUrl, string tenantId, string clientId, string clientSecret, string resource)
        {
            string authority = string.Format(claimsProviderUrl, tenantId);

            int retryCount = 0;
            bool retry;

            var formContent = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("resource", resource),
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_secret", clientSecret),
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