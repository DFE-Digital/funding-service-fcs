namespace AllocationDeliveryDomain.Endpoint.ActualsPull.Adapters
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;

    public class HttpService : IHttpService
    {
        private readonly HttpClient _httpClient = new HttpClient();

        public async Task<string> GetAsync(string authorizationToken, string requestUri)
        {
            using (HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Get, requestUri))
            {
                _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", authorizationToken);
                
                using (HttpResponseMessage response = await _httpClient.GetAsync(request.RequestUri)
                    .ConfigureAwait(false))
                {
                    response.EnsureSuccessStatusCode();

                    return await response.Content.ReadAsStringAsync();
                }
            }
        }
    }
}