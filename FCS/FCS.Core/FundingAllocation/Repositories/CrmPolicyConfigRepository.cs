namespace FundingAllocation.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using Infrastructure;

    public class CrmPolicyConfigRepository : ICrmPolicyConfigRepository
    {
        public string GetFundingTypeEntityReference(string restApiUrl, HttpClient httpClient, string accessToken, string id)
        {
            var url = $"{restApiUrl}sfa_fundingtypes?$select=sfa_fundingtypeid&$top=1&$filter=sfa_fundingtypecode eq '{id}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            var entityId = (string)content["value"][0]["sfa_fundingtypeid"];
            return entityId.ToUpper();
        }

        public string GetPeriodEntityReference(string restApiUrl, HttpClient httpClient, string accessToken, string periodName)
        {
            var url = $"{restApiUrl}sfa_periods?$select=sfa_periodid&$top=1&$filter=sfa_periodname eq '{periodName}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            var entityId = (string)content["value"][0]["sfa_periodid"];
            return entityId.ToUpper();
        }

        public string GetContractTypeId(string restApiUrl, HttpClient httpClient, string accessToken, string contractType)
        {
            var url = $"{restApiUrl}sfa_contracttypes?$select=sfa_contracttypeid&$top=1&$filter=sfa_name eq '{contractType}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            var entityId = (string)content["value"][0]["sfa_contracttypeid"];
            return entityId.ToUpper();
        }

        public string GetFspGroupId(string restApiUrl, HttpClient httpClient, string accessToken, string fspGroupCode)
        {
            var url = $"{restApiUrl}sfa_fspgroups?$select=sfa_fspgroupid&$top=1&$filter=sfa_name eq '{fspGroupCode}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            var entityId = (string)content["value"][0]["sfa_fspgroupid"];
            return entityId.ToUpper();
        }

        // GetOptionSets no longer needed for story 'CFS I1 - Import new allocations (Funding Allocation level only) (31583)'
        // Kept the method as we probably will need to get optionsets in the future
        public IReadOnlyCollection<OptionSet> GetOptionSets(string restApiUrl, HttpClient httpClient, string accessToken, string optionSetName)
        {
            var url = $"{restApiUrl}/EntityDefinitions(LogicalName='sfa_fundingallocation')/Attributes/Microsoft.Dynamics.CRM.PicklistAttributeMetadata?$select=LogicalName&$expand=OptionSet($select=Options)&$filter=LogicalName eq '{optionSetName}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            dynamic statusesElement = content.Last;
            var options = statusesElement.Value[0]["OptionSet"]["Options"];

            var statusesOptionSet = new List<OptionSet>();
            foreach (var option in options)
            {
                var optionSet = new OptionSet((int)option.Value, (string)option["Label"]["UserLocalizedLabel"]["Label"]);
                statusesOptionSet.Add(optionSet);
            }

            return statusesOptionSet.ToList();
        }
    }
}