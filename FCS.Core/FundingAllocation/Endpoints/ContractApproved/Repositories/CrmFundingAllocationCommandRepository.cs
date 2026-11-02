namespace FundingAllocation.Endpoints.ContractApproved.Repositories
{
    using System;
    using System.Threading.Tasks;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Microsoft.Extensions.Configuration;
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

        public async Task SetStatusToContractApproved(Guid crmEntityId)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);

            var crmFundingAllocation =
                new JObject(new JProperty("sfa_serviceresponse", sfa_FundingAllocationServiceResponse.ContractApproved));

            var destination = $"{_restApiUrl}sfa_fundingallocations({crmEntityId})";

            var request = new HttpRequestMessage(HttpMethod.Patch, destination)
            {
                Content = new StringContent(JObject.FromObject(crmFundingAllocation).ToString(), Encoding.UTF8,
                    "application/json")
            };

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = await _httpClient.SendAsync(request);

            response.EnsureSuccessStatusCode();
        }
    }
}