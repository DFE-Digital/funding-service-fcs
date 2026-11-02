namespace FundingAllocation.Repositories
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Services;

    public class CrmProviderRepository : ICrmProviderRepository
    {
        private readonly IConfigurationRoot _appConfiguration;
        private readonly HttpClient _httpClient;
        private readonly string _restApiUrl;

        public CrmProviderRepository(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            _httpClient = new HttpClient();
        }

        public async Task<string> GetProviderEntityReference(string ukprn)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            var url = $"{_restApiUrl}accounts?$select=accountid&$top=1&$filter=sfa_ukprn eq '{ukprn}'";

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = await _httpClient.GetAsync(url);

            var content = (JObject)JsonConvert.DeserializeObject(await response.Content.ReadAsStringAsync());

            return ((string)content["value"][0]["accountid"]).ToUpper();
        }
    }
}