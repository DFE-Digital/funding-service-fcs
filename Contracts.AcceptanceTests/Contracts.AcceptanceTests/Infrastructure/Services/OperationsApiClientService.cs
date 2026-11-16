namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using DTO;
    using Newtonsoft.Json;

    public static class OperationsApiClientService
    {
        private static readonly Uri BaseUrl = new Uri(TestConfiguration.Configuration["OpsWeb:Url"]);

        public static async Task<IReadOnlyCollection<LevyReportRow>> GetLevyContractsThatCannotBeAmended()
        {
            const string url = "/fcs-levy-contracts/not-amendable";
            
            using (var client = GetAuthorizedHttpClient())
            {
                //client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(sessionTokenName, token);
                //cookieContainer.Add(BaseUrl, new Cookie(sessionTokenName, token));
                var response = await client.GetAsync(url);
                string content =  await response.Content.ReadAsStringAsync();

                return JsonConvert.DeserializeObject<List<LevyReportRow>>(content);
            }
        }

        public static HttpClient GetAuthorizedHttpClient()
        {
            var client = new HttpClient{ BaseAddress = BaseUrl};

            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", AzureAuthenticator.GetAuthenticationResult("OPS_WEB"));
            return client;
        }
    }
}