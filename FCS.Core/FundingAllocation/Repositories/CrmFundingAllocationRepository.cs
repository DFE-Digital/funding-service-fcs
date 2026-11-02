namespace FundingAllocation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;
    using Endpoints.CreateFundingAllocationInCrm;
    using Extensions;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json.Linq;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class CrmFundingAllocationRepository : ICrmFundingAllocationRepository
    {
        private readonly IConfigurationRoot _appConfiguration;
        private readonly ICrmPolicyConfigRepository _crmPolicyConfigRepository;
        private readonly ICrmProviderRepository _crmProviderRepository;

        private readonly HttpClient _httpClient;
        private readonly string _restApiUrl;
        private const string CrmTableName = "sfa_fundingallocations";

        private readonly Dictionary<string, string> _fundingTypeEntityReferenceDictionary = new Dictionary<string, string>();
        private readonly Dictionary<string, string> _periodEntityReferenceDictionary = new Dictionary<string, string>();
        private readonly Dictionary<string, string> _contractTypeIdDictionary = new Dictionary<string, string>();
        private readonly Dictionary<string, string> _fspGroupIdDictionary = new Dictionary<string, string>();

        public CrmFundingAllocationRepository(IConfigurationRoot appConfiguration, ICrmPolicyConfigRepository crmPolicyConfigRepository, 
            ICrmProviderRepository crmProviderRepository)
        {
            _appConfiguration = appConfiguration;
            _crmPolicyConfigRepository = crmPolicyConfigRepository;
            _crmProviderRepository = crmProviderRepository;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            _httpClient = new HttpClient();
        }

        public async Task<Guid> AddFundingAllocation(FundingAllocationDto fundingAllocation, CrmFundingAllocationFks fundingAllocationFks)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            
            return await CreateCrmFundingAllocation(fundingAllocation, accessToken, fundingAllocationFks);
        }

        public async Task<CrmFundingAllocationFks> GetForeignKeys(FundingAllocationDto fundingAllocation)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);

            var fundingTypeEntityReference = GetFundingTypeEntityReference(accessToken, fundingAllocation.FundingType);
            var periodEntityReference = GetPeriodEntityReference(accessToken, fundingAllocation.Period);
            var providerEntityReference = await _crmProviderRepository.GetProviderEntityReference(fundingAllocation.UKPRN);
            var contractTypeId = GetIdFromDictionary(accessToken, fundingAllocation.ContractType, _contractTypeIdDictionary,
                _crmPolicyConfigRepository.GetContractTypeId);
            var fspGroupId = GetIdFromDictionary(accessToken, fundingAllocation.FSPGroup, _fspGroupIdDictionary,
                _crmPolicyConfigRepository.GetFspGroupId);

            return new CrmFundingAllocationFks
            (
                fundingTypeId: fundingTypeEntityReference,
                periodId: periodEntityReference,
                providerId: providerEntityReference,
                contractTypeId: contractTypeId,
                fspGroupId: fspGroupId
            );
        }

        public async Task Update(string crmFundingAllocationEntityId, string releaseGroupId, sfa_FundingAllocationServiceResponse serviceResponse)
        {
            string releaseGroupCrmBindValue =
                releaseGroupId.HasValue() ? $"/sfa_releasegroups({releaseGroupId})" : null;

            var crmReleaseGroup =
                new JObject(
                    new JProperty("sfa_releasegroup@odata.bind", releaseGroupCrmBindValue),
                    new JProperty("sfa_serviceresponse", serviceResponse)
                );
            var destinationUrl = $"{_restApiUrl}/sfa_fundingallocations({crmFundingAllocationEntityId})";

            await CrmHttpApiCaller.HttpPatch(destinationUrl, _httpClient, _appConfiguration, crmReleaseGroup);
        }

        public async Task SetToQueued(string crmFundingAllocationEntityId, string contractNumber, DateTime queuedOn)
        {
            var serviceResponse = sfa_FundingAllocationServiceResponse.ReleaseQueued;

            var crmFundingAllocation =
                new JObject(
                    new JProperty("sfa_queuedon", queuedOn),
                    new JProperty("sfa_queuedduetocontract", contractNumber),
                    new JProperty("sfa_serviceresponse", serviceResponse)
                );
            var destinationUrl = $"{_restApiUrl}/sfa_fundingallocations({crmFundingAllocationEntityId})";

            await CrmHttpApiCaller.HttpPatch(destinationUrl, _httpClient, _appConfiguration, crmFundingAllocation);
        }

        public async Task ClearQueued(string crmFundingAllocationEntityId)
        {
            var crmFundingAllocation =
                new JObject(
                    new JProperty("sfa_queuedon", null),
                    new JProperty("sfa_queuedduetocontract", null)
                );
            var destinationUrl = $"{_restApiUrl}/sfa_fundingallocations({crmFundingAllocationEntityId})";

            await CrmHttpApiCaller.HttpPatch(destinationUrl, _httpClient, _appConfiguration, crmFundingAllocation);
        }

        private async Task<Guid> CreateCrmFundingAllocation(FundingAllocationDto fundingAllocation, string accessToken, CrmFundingAllocationFks fundingAllocationFks)
        {
            var crmFundingAllocation =
                    new JObject(
                        new JProperty("sfa_name", fundingAllocation.FundingId),
                        new JProperty("sfa_fundingversion", fundingAllocation.FundingVersion),
                        new JProperty("sfa_allocationfundingstream", fundingAllocation.AllocationFundingStream),
                        new JProperty("sfa_ukprn", fundingAllocation.UKPRN),
                        new JProperty("sfa_value", fundingAllocation.Value),
                        new JProperty("sfa_fundingtype@odata.bind", $"/sfa_fundingtypes({fundingAllocationFks.FundingTypeId})"),
                        new JProperty("sfa_period@odata.bind", $"/sfa_periods({fundingAllocationFks.PeriodId})"),
                        new JProperty("sfa_provider@odata.bind", $"/accounts({fundingAllocationFks.ProviderId})"),
                        new JProperty("sfa_fspgroupid@odata.bind", $"/sfa_fspgroups({fundingAllocationFks.FspGroupId})"),
                        new JProperty("sfa_contracttypeid@odata.bind", $"/sfa_contracttypes({fundingAllocationFks.ContractTypeId})"),
                        new JProperty("sfa_releasegroup@odata.bind", $"/sfa_releasegroups({fundingAllocationFks.ReleaseGroupId})")
                    );

            var destination = $"{_restApiUrl}{CrmTableName}";

            var request = new HttpRequestMessage(HttpMethod.Post, destination);
            request.Content = new StringContent(JObject.FromObject(crmFundingAllocation).ToString(), Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = await _httpClient.SendAsync(request);

            if (response.StatusCode != HttpStatusCode.NoContent || !response.Headers.Contains("OData-EntityId"))
            {
                var error = await response.Content.ReadAsStringAsync();
                throw new InvalidOperationException(
                    $"Error in CrmFundingAllocationRepository.CreateCrmFundingAllocation - statusCode:{response.StatusCode}, error:{error}");
            }

            return GetEntityId(response.Headers.GetValues("OData-EntityId").FirstOrDefault());
        }

        private static Guid GetEntityId(string oDataEntityId)
        {
            var idWWithClosedBracket = oDataEntityId.Split('(');
            var entityId = idWWithClosedBracket[1].Split(')')[0].ToUpper();
            return new Guid(entityId);
        }

        private string GetFundingTypeEntityReference(string accessToken, string fundingType)
        {
            return _fundingTypeEntityReferenceDictionary.GetOrAdd(fundingType,
                () => _crmPolicyConfigRepository.GetFundingTypeEntityReference(_restApiUrl, _httpClient, accessToken, fundingType));
        }

        private string GetPeriodEntityReference(string accessToken, string period)
        {
            return _periodEntityReferenceDictionary.GetOrAdd(period,
                () => _crmPolicyConfigRepository.GetPeriodEntityReference(_restApiUrl, _httpClient, accessToken, period));
        }

        private string GetIdFromDictionary(string accessToken, string key, IDictionary<string, string> idDictionary,
            Func<string, HttpClient, string, string, string> getId)
        {
            return idDictionary.GetOrAdd(key, ()=> getId(_restApiUrl, _httpClient, accessToken, key));
        }
    }
}