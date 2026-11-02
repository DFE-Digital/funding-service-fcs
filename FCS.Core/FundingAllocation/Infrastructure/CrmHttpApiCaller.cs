namespace FundingAllocation.Infrastructure
{
    using System;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Services;

    public static class CrmHttpApiCaller
    {
        public static JObject HttpGet(string url, HttpClient httpClient, string accessToken)
        {
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(url).Result;

            return (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);
        }

        public static async Task<JObject> HttpGetAsync(string url, HttpClient httpClient, string accessToken)
        {
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = await httpClient.GetAsync(url);
            var result = await response.Content.ReadAsStringAsync();

            return (JObject)JsonConvert.DeserializeObject(result);
        }

        public static async Task HttpPost(string url, HttpClient httpClient, IConfigurationRoot appConfiguration, object objectToPost)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var request = new HttpRequestMessage(HttpMethod.Post, url)
            {
                Content = new StringContent(JObject.FromObject(objectToPost).ToString(), Encoding.UTF8,
                    "application/json")
            };

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = await httpClient.SendAsync(request);
            if (response.StatusCode != HttpStatusCode.NoContent)
            {
                var responseContent = await response.Content.ReadAsStringAsync();

                var result = (JObject)JsonConvert.DeserializeObject(responseContent);

                if (result != null)
                {
                    throw new ArgumentException($"The object: {objectToPost}, POST to this url:{url}, has caused this issue: {result}");
                }
            }
        }

        public static async Task HttpPatch(string url, HttpClient httpClient, IConfigurationRoot appConfiguration, object objectToPatch)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var request = new HttpRequestMessage(HttpMethod.Patch, url)
            {
                Content = new StringContent(JObject.FromObject(objectToPatch).ToString(), Encoding.UTF8,
                    "application/json")
            };

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = await httpClient.SendAsync(request);
            if (response.StatusCode != HttpStatusCode.NoContent)
            {
                var responseContent = await response.Content.ReadAsStringAsync();

                var result = (JObject)JsonConvert.DeserializeObject(responseContent);

                if (result != null)
                {
                    throw new ArgumentException($"The object: {objectToPatch}, PATCH to this url:{url}, has caused this issue: {result}");
                }
            }
        }
    }
}