namespace FundingAllocation.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web;
    using Infrastructure;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json.Linq;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public class CrmContractRepository : ICrmContractRepository
    {
        private readonly string _restApiUrl;
        private readonly IConfigurationRoot _appConfiguration;
        private readonly IHttpClientFactory _httpClientFactory;

        public CrmContractRepository(IConfigurationRoot appConfiguration, IHttpClientFactory httpClientFactory)
        {
            _appConfiguration = appConfiguration;
            _httpClientFactory = httpClientFactory;
            _restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
        }

        public async Task<IReadOnlyCollection<CrmContractStatusInfo>> GetContractStatusInfosForUkprn(int ukprn, string fundingTypeCode)
        {
            const int contractHierarchyType = (int)sfa_contracthierarchytype.Contract;

            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            string fetchXml = @$"<fetch mapping='logical'>  
                                    <entity name='sfa_contract'>   
                                      <attribute name='sfa_number'/>
                                      <attribute name='sfa_contractstatus'/>
                                      <attribute name='sfa_latestversion'/>
                                      <attribute name='sfa_version'/>
                                      <attribute name='sfa_subversion'/>
                                      <attribute name='createdon'/>
                                      <attribute name='sfa_contractid'/>
                                      <attribute name='sfa_lastapprovedversion'/>
                                      <attribute name='sfa_amendmenttype'/>
                                      <filter type='and'>
                                        <condition attribute='sfa_hierarchytype' operator='eq' value='{contractHierarchyType}' />
                                        <condition attribute='sfa_ukprn' operator='eq' value='{ukprn}' />
                                      </filter>
                                      <link-entity name='sfa_fundingtype' to='sfa_fundingtype' link-type='inner' alias='ft'>
                                                <attribute name='sfa_fundingtypecode' />
                                                <filter type='and'>   
                                                    <condition attribute='sfa_fundingtypecode' operator='eq' value='{fundingTypeCode}' />   
                                                </filter>
                                      </link-entity>
                                      <link-entity name='sfa_period' to='sfa_periodid' link-type='inner' alias='p'>
                                                <attribute name='sfa_periodname' />
                                      </link-entity>
                                      <link-entity name='sfa_contract' to='sfa_parentcontractid' link-type='inner' alias='master'>
                                                <attribute name='sfa_number' />
                                      </link-entity>
                                      <link-entity name='sfa_status' to='sfa_substatus' link-type='inner' alias='s'>
                                                <attribute name='sfa_name' />
                                                <attribute name='sfa_statusid' />
                                      </link-entity>
                                      </entity>   
                                </fetch>";

            var encoded = HttpUtility.UrlEncode(fetchXml);
            
            var url = $"{_restApiUrl}sfa_contracts?fetchXml={encoded}";
            var content = await CrmHttpApiCaller.HttpGetAsync(url, _httpClientFactory.CreateClient(), accessToken);

            List<CrmContractStatusInfo> crmContractStatusInfos = new List<CrmContractStatusInfo>();
            if (content["value"].HasValues)
            {
                var listOfCrmContractStatusInfos = content["value"].ToList();
                listOfCrmContractStatusInfos.ForEach(row =>
                    crmContractStatusInfos.Add(new CrmContractStatusInfo(
                        (string)row["sfa_number"],
                        ToContractStatus((int)row["sfa_contractstatus"]),
                        subStatus:(string)row["s.sfa_name"],
                        (bool)(row["sfa_latestversion"] ?? false),
                        (int)row["sfa_version"],
                        (int)row["sfa_subversion"],
                        ToDateTime((string)row["createdon"]),
                        (string)row["sfa_contractid"],
                        (string)row["master.sfa_number"],
                        (string)row["p.sfa_periodname"],
                        (string)row["ft.sfa_fundingtypecode"],
                        (bool)row["sfa_lastapprovedversion"],
                        ToAmendmentType(row["sfa_amendmenttype"]))));
            }

            return crmContractStatusInfos.ToList();
        }

        public async Task<IReadOnlyCollection<CrmAllocationInfo>> GetAllocationInfosForContractEntityId(string crmEntityId)
        {
            var accessToken = CrmAccessTokenFactory.GetAccessToken(_appConfiguration);
            var httpClient = _httpClientFactory.CreateClient();
            var url = $"{_restApiUrl}sfa_contractallocations?$select=sfa_contractallocationnumber,sfa_deliveryorganisationukprn,_sfa_fundingstreamid_value&$filter=_sfa_contractid_value eq '{crmEntityId}'";

            httpClient.DefaultRequestHeaders.Add("Prefer", "odata.include-annotations=\"*\"");

            var content = await CrmHttpApiCaller.HttpGetAsync(url, httpClient, accessToken);

            var crmAllocationInfos = new List<CrmAllocationInfo>();

            if (content["value"].HasValues)
            {
                var listOfCrmAllocationInfos = content["value"].ToList();

                listOfCrmAllocationInfos.ForEach(row =>
                    crmAllocationInfos.Add(new CrmAllocationInfo(
                        (string)row["_sfa_fundingstreamid_value@OData.Community.Display.V1.FormattedValue"],
                        (string)row["sfa_deliveryorganisationukprn"],
                        (string)row["sfa_contractallocationnumber"])));
            }

            return crmAllocationInfos;
        }

        private static string ToContractStatus(int contractstatus)
        {
            return ((sfa_contractstatus)contractstatus).ToString();
        }

        private static string ToAmendmentType(JToken amendmentTypeJToken)
        {
            if (amendmentTypeJToken is JValue amendmentTypeJValue)
            {
                return ((sfa_amendmenttype)(long)amendmentTypeJValue.Value).ToString();
            }

            return string.Empty;
        }

        private static DateTime ToDateTime(string date)
        { 
            return DateTime.Parse(date, CultureInfo.CreateSpecificCulture("en-US"));
        }
    }
}