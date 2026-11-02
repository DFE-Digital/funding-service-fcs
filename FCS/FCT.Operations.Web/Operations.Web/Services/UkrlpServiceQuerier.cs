using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Policy;
using System.Threading.Tasks;
using System.Web.UI.WebControls;
namespace Operations.Web.Services
{
    public class UkrlpServiceQuerier : IUkrlpServiceQuerier
    {
        private const string AadInstance = "https://login.microsoftonline.com/{0}";
        private static readonly string OauthTenant = ConfigurationManager.AppSettings["UkrlpApi:Tenant"];
        private static readonly string clientId = ConfigurationManager.AppSettings["UkrlpApi:ClientId"];
        private static readonly string clientSecret = ConfigurationManager.AppSettings["UkrlpApi:ClientSecret"];
        private static readonly string scope = ConfigurationManager.AppSettings["UkrlpApi:Scope"];
        private static readonly string subscriptionKey = ConfigurationManager.AppSettings["UkrlpApi:Subscription"];
        private static readonly string ukrlpBaseUrl = ConfigurationManager.AppSettings["UkrlpService:Url"];

        public UkrlpServiceQuerier()
        { }
        public bool DoesUkprnExistInUkrlp1(string[] ukprns)
        {
            return Task.Run(() =>
                 DoesUkprnExistInUkrlp(ukprns)
             ).GetAwaiter().GetResult();

        }
        public async Task<bool> DoesUkprnExistInUkrlp(string[] ukprns)
        {
            try
            {
                var url = $"{ukrlpBaseUrl}/api/providers?UKPRNS={string.Join(",", ukprns)}";

                var token = await GetAccessTokenAsync();

                return await CallApi(url, token);

            }
            catch (Exception ex)
            {
                return false;
            }
        }

        private static string GetRandomNumberAsString()
        {
            Random random = new Random();
            return random.Next(int.MaxValue).ToString();
        }
        private async Task<bool> CallApi(string url, string token)
        {
            var results = new List<object>();

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", subscriptionKey);
                client.DefaultRequestHeaders.Add("api-Version", "1");
                client.DefaultRequestHeaders.Add("Accept", "application/x-ndjson");

                var response = await client.GetAsync(url);

                var content = await response.Content.ReadAsStringAsync();
                if (response.IsSuccessStatusCode)
                {
                    // Service is available
                    return true;
                }
                else
                {
                    // Service responded but with error status
                    Console.WriteLine($"Error Response Content: {content}");
                    return false;
                }
            }
        }

        private async Task<string> GetAccessTokenAsync()
        {
            var authority = string.Format(AadInstance, OauthTenant);
            var client = new HttpClient();
            var request = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("grant_type", "client_credentials"),
                new KeyValuePair<string, string>("client_id", clientId),
                new KeyValuePair<string, string>("client_secret", clientSecret),
                new KeyValuePair<string, string>("scope", scope)
            });

            var response = await client.PostAsync(authority + "/oauth2/v2.0/token", request);
            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();
            dynamic token = JsonConvert.DeserializeObject(json);

            return token.access_token;
        }
    }
}