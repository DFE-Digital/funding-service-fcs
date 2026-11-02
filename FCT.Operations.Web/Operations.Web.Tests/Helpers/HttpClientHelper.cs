namespace Operations.Web.Tests.Helpers
{
    using System;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using SFA.FCT.CrossDomain.Integration.Common.Authentication;

    public static class HttpClientHelper
    {
        public static HttpClient GetClientWithAuthorizedSession(Uri baseUrl)
        {
            //string url = "/session";
            //HttpResponseMessage httpResponseMessage = null;
            //const string authenticationToken =
          
           // const string sessionTokenName = "session-token";

           var http = GetAuthorizedHttpClient(baseUrl);
           //http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
           //httpResponseMessage =
           //     http.PostAsync(url,
           //         new StringContent($"\"{authenticationToken}\"", Encoding.UTF8, "application/json")).Result;

            return http;
            
            //string responseBody = httpResponseMessage.Content.ReadAsStringAsync().Result;
            //JsonToken token = JsonConvert.DeserializeObject<JsonToken>(responseBody);

            //var cookieContainer = new CookieContainer();
            //var handler = new HttpClientHandler { CookieContainer = cookieContainer };
            //var authorizedHttpClient = GetAuthorizedHttpClient(baseUrl, handler);
            //authorizedHttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(sessionTokenName, token.Token);
            
            //cookieContainer.Add(baseUrl, new Cookie(sessionTokenName, token.Token));

            //return authorizedHttpClient;
        }

        private class JsonToken
        {
            public string Token { get; set; }
        }

        public static HttpClient GetAuthorizedHttpClient(Uri baseUrl, HttpClientHandler clientHandler = null)
        {
            HttpClient httpClient = null;
            if (clientHandler != null)
            {
                httpClient = new HttpClient(clientHandler) { BaseAddress = baseUrl };
            }
            else
            {
                httpClient = new HttpClient { BaseAddress = baseUrl };
            }

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult("OPS_WEB"));
            return httpClient;
        }
    }
}