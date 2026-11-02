namespace FundingAllocation.Endpoints.DocumentGenerationComplete.Repositories
{
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmFundingAllocationCommandRepository : ICrmFundingAllocationCommandRepository
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly IConfigurationRoot _appConfiguration;
        private readonly string _restApiUrl;

        public CrmFundingAllocationCommandRepository(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
        }

        public async Task UpdateFundingAllocation(string fundingId, string contractNumber, int contractVersionNumber, 
            sfa_FundingAllocationServiceResponse sfaFundingAllocationServiceResponse)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);

            var fundingAllocationEntityReference = await GetFundingAllocationEntityReference(fundingId);

            var crmFundingAllocation =
                new JObject(
                    new JProperty("sfa_contractversion", contractVersionNumber),
                    new JProperty("sfa_serviceresponse", sfaFundingAllocationServiceResponse),
                    new JProperty("sfa_contract", contractNumber)
                );

            var destination = $"{_restApiUrl}sfa_fundingallocations({fundingAllocationEntityReference})";

            var request = new HttpRequestMessage(HttpMethod.Patch, destination)
            {
                Content = new StringContent(JObject.FromObject(crmFundingAllocation).ToString(), Encoding.UTF8,
                    "application/json")
            };

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = await _httpClient.SendAsync(request);

            response.EnsureSuccessStatusCode();
        }

        private async Task<string> GetFundingAllocationEntityReference(string fundingId)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);

            var url = $"{_restApiUrl}sfa_fundingallocations?$select=sfa_fundingallocationid&$top=1&$filter=sfa_name eq '{fundingId}'";

            var content = await HttpGet(url, accessToken);

            var entityId = (string)content["value"][0]["sfa_fundingallocationid"];
            return entityId.ToUpper();
        }

        private async Task<JObject> HttpGet(string url, string accessToken)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = await _httpClient.GetAsync(url);

            return (JObject)JsonConvert.DeserializeObject(await response.Content.ReadAsStringAsync());
        }
    }
}
