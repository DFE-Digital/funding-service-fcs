namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CrmFundingAllocationRepositoryTests
    {
        private const string CrmFundingAllocationTableName = "sfa_fundingallocations";
        private const string CrmReleaseGroupTableName = "sfa_releasegroups";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationRepository_AddFundingAllocation_ShouldStoreFundingAllocationInCrm()
        {
            // arrange 
            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            var (ukprn, providerEntityReference) = GetAnyProviderDetails(accessToken, restApiUrl);

            var fundingId = "AddTest_PSG-AY-2021-Payment-AcademyTrust-10083351-1_0";
            var fundingAllocation = PopulateFundingAllocation(ukprn, fundingId);

            ClearDownCrmFundingAllocation(fundingAllocation.FundingId, restApiUrl, accessToken);

            const string releaseGroupName = "AddTest_ReleaseGroupName";
            ClearDownCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);
            var releaseGroupId = CreateCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);

            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();
            var crmProviderRepository = new CrmProviderRepository(appConfiguration);
            var repository = new CrmFundingAllocationRepository(appConfiguration, crmPolicyConfigRepository, crmProviderRepository);

            var foreignKeys = repository.GetForeignKeys(fundingAllocation).Result;
            foreignKeys.ReleaseGroupId = releaseGroupId;

            // act
            var entityId = repository.AddFundingAllocation(fundingAllocation, foreignKeys).Result;

            // assert
            var fundingAllocationIdsCreated = GetFundingAllocationIds(fundingAllocation.FundingId, restApiUrl, accessToken);
            Assert.AreEqual(1, fundingAllocationIdsCreated.Count, $"FundingAllocation '{fundingAllocation.FundingId}' was not created");
            Assert.AreEqual(entityId, new Guid(fundingAllocationIdsCreated.First().ToUpper()), "Unexpected FundingAllocation entity id");

            // Simple data item assets
            var fundingAllocationCreated = GetCrmFundingAllocation(fundingAllocation.FundingId, restApiUrl, accessToken);

            Assert.AreEqual(fundingAllocation.FundingId, (string)fundingAllocationCreated["sfa_name"], "FundingAllocation FundingId was incorrect");
            Assert.AreEqual(fundingAllocation.FundingVersion, (string)fundingAllocationCreated["sfa_fundingversion"], "FundingAllocation FundingVersion was incorrect");
            Assert.AreEqual(foreignKeys.ContractTypeId, fundingAllocationCreated["_sfa_contracttypeid_value"].ToString().ToUpper(), "FundingAllocation ContractType was incorrect");
            Assert.AreEqual(fundingAllocation.AllocationFundingStream, (string)fundingAllocationCreated["sfa_allocationfundingstream"], "FundingAllocation AllocationFundingStream was incorrect");
            Assert.AreEqual(foreignKeys.FspGroupId, fundingAllocationCreated["_sfa_fspgroupid_value"].ToString().ToUpper(), "FundingAllocation FSPGroup was incorrect");
            Assert.AreEqual(fundingAllocation.UKPRN, (string)fundingAllocationCreated["sfa_ukprn"], "FundingAllocation UKPRN was incorrect");
            Assert.AreEqual(fundingAllocation.Value, (decimal)fundingAllocationCreated["sfa_value_base"], "FundingAllocation Value was incorrect");

            // Entity Reference asserts
            var fundingTypeEntityReference = GetFundingTypeEntityReference(accessToken, restApiUrl, fundingAllocation.FundingType);
            var periodEntityReference = GetPeriodEntityReference(accessToken, restApiUrl, fundingAllocation.Period);

            Assert.AreEqual(fundingTypeEntityReference, ((string)fundingAllocationCreated["_sfa_fundingtype_value"]).ToUpper(), "FundingAllocation FundingType entity reference was incorrect");
            Assert.AreEqual(periodEntityReference, ((string)fundingAllocationCreated["_sfa_period_value"]).ToUpper(), "FundingAllocation Period was incorrect");
            Assert.AreEqual(providerEntityReference, ((string)fundingAllocationCreated["_sfa_provider_value"]).ToUpper(), "FundingAllocation Provider was incorrect");

            // OptionSet asserts
            var statusOptionSets = GetOptionSets("sfa_status", restApiUrl, accessToken);
            var statusOptionSetValue = statusOptionSets.First(optionSet => optionSet.OptionValueLabel == "Scheduling").OptionSetNumber;

            var subStatusOptionSets = GetOptionSets("sfa_substatus", restApiUrl, accessToken);
            var subStatusOptionValue = subStatusOptionSets.First(optionSet => optionSet.OptionValueLabel == "Awaiting Release").OptionSetNumber;

            Assert.AreEqual(statusOptionSetValue, (int)fundingAllocationCreated["sfa_status"], "FundingAllocation Status was incorrect");
            Assert.AreEqual(subStatusOptionValue, (int)fundingAllocationCreated["sfa_substatus"], "FundingAllocation Substatus was incorrect");
        }

        private static void ClearDownCrmFundingAllocation(string fundingId, string restApiUrl, string accessToken)
        {
            var fundingAllocationIdsToRemove = GetFundingAllocationIds(fundingId, restApiUrl, accessToken).ToList();

            fundingAllocationIdsToRemove.ForEach(fundingAllocationId => DeleteCrmFundingAllocation(fundingAllocationId, restApiUrl, accessToken));
        }

        private static IReadOnlyCollection<string> GetFundingAllocationIds(string sfaName, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}{CrmFundingAllocationTableName}?$filter=sfa_name eq '{sfaName}'";

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(api).Result;

                Assert.IsTrue(response.IsSuccessStatusCode, $"CRM rest api call to get FundingAllocations for sfa_name: {sfaName} failed");

                var content = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return content["value"].Select(seq => seq["sfa_fundingallocationid"]).Values<string>().ToList();
            }
        }

        private static void DeleteCrmFundingAllocation(string fundingId, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}{CrmFundingAllocationTableName}({fundingId})";

            using (var httpClient = new HttpClient())
            {
                var request = new HttpRequestMessage(HttpMethod.Delete, api);
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                var response = httpClient.SendAsync(request).Result;
                Assert.IsTrue(response.IsSuccessStatusCode, $"Did not delete Funding Allocation: {fundingId}");
            }
        }

        private static JToken GetCrmFundingAllocation(string sfaName, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}{CrmFundingAllocationTableName}?$filter=sfa_name eq '{sfaName}'";

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(api).Result;

                Assert.IsTrue(response.IsSuccessStatusCode, "CRM rest api call to get FundingAllocation failed");

                var content = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return content["value"].First;
            }
        }

        private static FundingAllocationDto PopulateFundingAllocation(string ukprn, string fundingId)
        {
            return new FundingAllocationDto
            {
                FundingId = fundingId,
                FundingVersion = "1_0",
                FundingType = "EDSK",
                Period = "AY2021", 
                ContractType = "Conditions of Funding (Grant) (College)",
                AllocationFundingStream = "PSG",
                FSPGroup = "16-19ED2021",
                UKPRN = ukprn,
                Value = (decimal)9999.99
            };
        }

        private static string GetFundingTypeEntityReference(string accessToken, string restApiUrl, string id)
        {
            var url = $"{restApiUrl}sfa_fundingtypes?$filter=sfa_fundingtypecode eq '{id}'";
            var content = HttpGet(url, accessToken);

            var entityId = (string)content["value"][0]["sfa_fundingtypeid"];
            return entityId.ToUpper();
        }

        private static string GetPeriodEntityReference(string accessToken, string restApiUrl, string periodName)
        {
            var url = $"{restApiUrl}sfa_periods?$filter=sfa_periodname eq '{periodName}'";
            var content = HttpGet(url, accessToken);

            var entityId = (string)content["value"][0]["sfa_periodid"];
            return entityId.ToUpper();
        }

        public Tuple<string, string> GetAnyProviderDetails(string accessToken, string restApiUrl)
        {
           var url = $"{restApiUrl}accounts?$select=name,sfa_ukprn&$top=1&$filter=sfa_ukprn ne null";
           var content = HttpGet(url, accessToken);

           return Tuple.Create((string)content["value"][0]["sfa_ukprn"], ((string)content["value"][0]["accountid"]).ToUpper());
        }

        private static JObject HttpGet(string url, string accessToken)
        {
            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(url).Result;

                return (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);
            }
        }

        private static List<OptionSet> GetOptionSets(string optionSetName, string restApiUrl, string accessToken)
        {
            var url = $"{restApiUrl}/EntityDefinitions(LogicalName='sfa_fundingallocation')/Attributes/Microsoft.Dynamics.CRM.PicklistAttributeMetadata?$select=LogicalName&$expand=OptionSet($select=Options)&$filter=LogicalName eq '{optionSetName}'";
            var content = HttpGet(url, accessToken);

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

        private static void ClearDownCrmReleaseGroup(string releaseGroupId, string restApiUrl, string accessToken)
        {
            var releaseGroupIdsToRemove = GetReleaseGroupIds(releaseGroupId, restApiUrl, accessToken).ToList();

            releaseGroupIdsToRemove.ForEach(crmReleaseGroupId => DeleteCrmReleaseGroup(crmReleaseGroupId, restApiUrl, accessToken));
        }

        private static void DeleteCrmReleaseGroup(string releaseGroupId, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}{CrmReleaseGroupTableName}({releaseGroupId})";

            using (var httpClient = new HttpClient())
            {
                var request = new HttpRequestMessage(HttpMethod.Delete, api);
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                var response = httpClient.SendAsync(request).Result;
                Assert.IsTrue(response.IsSuccessStatusCode, $"Did not delete Release Group: {releaseGroupId}");
            }
        }

        private static IReadOnlyCollection<string> GetReleaseGroupIds(string sfaName, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_releasegroups?$filter=sfa_name eq '{sfaName}'";

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(api).Result;

                Assert.IsTrue(response.IsSuccessStatusCode, $"CRM rest api call to get ReleaseGroups for sfa_name: {sfaName} failed");

                var content = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return content["value"].Select(seq => seq["sfa_releasegroupid"]).Values<string>().ToList();
            }
        }

        private static string CreateCrmReleaseGroup(string releaseGroupName, string restApiUrl, string accessToken)
        {
            var crmReleaseGroup = new JObject(new JProperty("sfa_name", releaseGroupName));

            var destination = $"{restApiUrl}{CrmReleaseGroupTableName}";

            var request = new HttpRequestMessage(HttpMethod.Post, destination);
            request.Content = new StringContent(JObject.FromObject(crmReleaseGroup).ToString(), Encoding.UTF8, "application/json");

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                var response = httpClient.SendAsync(request).Result;
                Assert.IsTrue(response.IsSuccessStatusCode, $"CRM rest api call to add ReleaseGroup for sfa_name: {releaseGroupName} failed");

                return GetEntityId(response.Headers.GetValues("OData-EntityId").FirstOrDefault()).ToString().ToUpper();
            }
        }

        private static Guid GetEntityId(string oDataEntityId)
        {
            var idWWithClosedBracket = oDataEntityId.Split('(');
            var entityId = idWWithClosedBracket[1].Split(')')[0].ToUpper();
            return new Guid(entityId);
        }

    }
}