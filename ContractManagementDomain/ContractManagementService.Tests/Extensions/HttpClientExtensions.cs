namespace ContractManagementService.Tests.Extensions
{
    using System.Text;
    using System.Net.Http;
    using System.Threading.Tasks;
    using Newtonsoft.Json;

    public static class HttpClientExtensions
    {
        public static async Task<HttpResponseMessage> PostAsJsonAsync(this HttpClient httpClient, string url, object objectToPost)
        {
            var json = JsonConvert.SerializeObject(objectToPost);
            var stringContent = new StringContent(json, Encoding.UTF8, "application/json");

            return await httpClient.PostAsync(url, stringContent);
        }
    }
}
