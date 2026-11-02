namespace FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using System.Net.Http;
    using System.Threading.Tasks;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Infrastructure;

    public class CrmReleaseGroupRepository : ICrmReleaseGroupRepository
    {
        private readonly HttpClient HttpClient = new HttpClient();
        private readonly string _restApiUrl;
        private readonly IConfigurationRoot _appConfiguration;

        public CrmReleaseGroupRepository(IConfigurationRoot appConfiguration)
        {
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1";
            _appConfiguration = appConfiguration;
        }

        public async Task SetToReleased(string crmEntityId)
        {
            var crmReleaseGroup =
                new JObject(
                    new JProperty("sfa_releasestatus", sfa_ReleaseGroupStatus.Released)
                );

            var destinationUrl = $"{_restApiUrl}/sfa_releasegroups({crmEntityId})";

            await CrmHttpApiCaller.HttpPatch(destinationUrl, HttpClient, _appConfiguration, crmReleaseGroup);
        }
    }
}