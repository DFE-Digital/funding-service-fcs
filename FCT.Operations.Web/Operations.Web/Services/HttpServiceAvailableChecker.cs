namespace Operations.Web.Services
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using static Factory.OAuthAccessTokenFactoryNoCache;

    public class HttpServiceAvailableChecker : IHttpServiceAvailableChecker
    {
        private static readonly HttpClient HttpClient = new HttpClient();

        public async Task<bool> GetSuccessFromCallingUrl(string url, SecureApplication service)
        {
            var accessToken = GetAccessToken(service);
            
            HttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            
            var httpResponseMessage = await HttpClient.GetAsync(url);

            return httpResponseMessage.IsSuccessStatusCode;
        }
    }
}