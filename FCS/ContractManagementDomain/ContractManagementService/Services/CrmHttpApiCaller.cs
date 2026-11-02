using System.Threading.Tasks;

namespace ContractManagementService.Services
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;

    public class CrmHttpApiCaller
    {
        public static async Task<JObject> HttpGetAsync(string url, HttpClient httpClient, string accessToken)
        {
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = await httpClient.GetAsync(url);
            var result = await response.Content.ReadAsStringAsync();

            return (JObject)JsonConvert.DeserializeObject(result);
        }
    }
}
