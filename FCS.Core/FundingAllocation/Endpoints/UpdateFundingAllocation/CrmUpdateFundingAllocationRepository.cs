namespace FundingAllocation.Endpoints.UpdateFundingAllocation
{
    using System.Net.Http;
    using System.Threading.Tasks;
    using Extensions;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class CrmUpdateFundingAllocationRepository : ICrmUpdateFundingAllocationRepository
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly string _restApiUrl;
        private readonly IConfigurationRoot _appConfiguration;

        public CrmUpdateFundingAllocationRepository(IConfigurationRoot appConfiguration)
        {
            _appConfiguration = appConfiguration;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1";
        }

        public async Task ReturnToScheduling(string crmFundingAllocationEntityId, sfa_FundingAllocationServiceResponse serviceResponse)
        {
            var crmFundingAllocation =
                new JObject(
                    new JProperty("sfa_contract", null),
                    new JProperty("sfa_contractversion", null),
                    new JProperty("sfa_releasegroup@odata.bind", null),
                    new JProperty("sfa_serviceresponse", serviceResponse)
                );

            var destinationUrl = $"{_restApiUrl}/sfa_fundingallocations({crmFundingAllocationEntityId})";

            await CrmHttpApiCaller.HttpPatch(destinationUrl, _httpClient, _appConfiguration, crmFundingAllocation);
        }
    }
}