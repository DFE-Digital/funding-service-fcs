namespace FundingAllocation.Repositories
{
    using System.Net.Http;
    using System.Threading.Tasks;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json.Linq;

    public class CrmReleaseGroupRepository : ICrmReleaseGroupRepository
    {
        private static readonly HttpClient HttpClient = new HttpClient();
        private readonly string _restApiUrl;
        private readonly IConfigurationRoot _appConfiguration;

        public CrmReleaseGroupRepository(IConfigurationRoot appConfiguration)
        {
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1";
            _appConfiguration = appConfiguration;
        }

        public async Task CreateReleaseGroup(
            string releaseGroupName,
            string fundingTypeId,
            string fundingPeriodId,
            string fspGroupId,
            string contractTypeId,
            string crmReleaseGroupEntityId)
        {
            var crmReleaseGroup =
                new JObject(
                    new JProperty("sfa_name", releaseGroupName),
                    new JProperty("sfa_releasegroupid", crmReleaseGroupEntityId),
                    new JProperty("sfa_fundingtype@odata.bind", $"/sfa_fundingtypes({fundingTypeId})"),
                    new JProperty("sfa_fundingperiod@odata.bind", $"/sfa_periods({fundingPeriodId})"),
                    new JProperty("sfa_fspgroup@odata.bind", $"/sfa_fspgroups({fspGroupId})"),
                    new JProperty("sfa_contracttype@odata.bind", $"/sfa_contracttypes({contractTypeId})")
                );

            var destinationUrl = $"{_restApiUrl}/sfa_releasegroups";
            
            await CrmHttpApiCaller.HttpPost(destinationUrl, HttpClient, _appConfiguration, crmReleaseGroup);
        }
    }
}
