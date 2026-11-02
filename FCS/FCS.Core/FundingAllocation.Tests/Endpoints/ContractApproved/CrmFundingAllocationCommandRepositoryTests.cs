namespace FundingAllocation.Tests.Endpoints.ContractApproved
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using FundingAllocation.Endpoints.ContractApproved.Repositories;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class CrmFundingAllocationCommandRepositoryTests
    {
        private const string CrmFundingAllocationTableName = "sfa_fundingallocations";
        private const string CrmReleaseGroupTableName = "sfa_releasegroups";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationCommandRepository_SetStatusToContractApproved_ShouldResultInStatusAndSubStatusSetToContractApproved()
        {
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            const string fundingId = "SetStatusToContractApprovedTest_PSG-AY-2021-Payment-AcademyTrust-10083351-1_0";
            var ukprn = GetUkprnFromAccountTable(accessToken, restApiUrl);

            const string releaseGroupName = "ContractApprovedTest_ReleaseGroupName";
            ClearDownCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);
            var releaseGroupId = CreateCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);

            var (fundingAllocation, crmEntityId) = ClearAndCreateFundingAllocation(appConfiguration, restApiUrl, accessToken, fundingId, ukprn, releaseGroupId);

            var repository = new CrmFundingAllocationCommandRepository(appConfiguration);

            // act
            repository.SetStatusToContractApproved(crmEntityId).Wait();

            // assert
            var updatedFundingAllocation = GetCrmFundingAllocation(fundingAllocation.FundingId, restApiUrl, accessToken);

            // OptionSet asserts
            var statusOptionSets = GetOptionSets("sfa_status", restApiUrl, accessToken);
            var statusOptionSetValue = statusOptionSets.First(optionSet => optionSet.OptionValueLabel == "Contract Approved").OptionSetNumber;

            var subStatusOptionSets = GetOptionSets("sfa_substatus", restApiUrl, accessToken);
            var subStatusOptionValue = subStatusOptionSets.First(optionSet => optionSet.OptionValueLabel == "Contract Approved").OptionSetNumber;

            Assert.AreEqual(statusOptionSetValue, (int)updatedFundingAllocation["sfa_status"], "Expected CRM FundingAllocation Status 'Contract Approved' is incorrect");
            Assert.AreEqual(subStatusOptionValue, (int)updatedFundingAllocation["sfa_substatus"], "Expected CRM FundingAllocation Substatus 'Contract Approved' is incorrect");
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

        private static Tuple<FundingAllocationDto, Guid> ClearAndCreateFundingAllocation(IConfigurationRoot appConfiguration, string restApiUrl, string accessToken, string fundingId, string ukprn, string releaseGroupId)
        {
            var fundingAllocationDto = PopulateFundingAllocationDto(ukprn, fundingId);

            ClearDownCrmFundingAllocation(fundingAllocationDto.FundingId, restApiUrl, accessToken);

            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();
            var crmProviderRepository = new CrmProviderRepository(appConfiguration);
            var repository = new CrmFundingAllocationRepository(appConfiguration, crmPolicyConfigRepository, crmProviderRepository);

            var foreignKeys = repository.GetForeignKeys(fundingAllocationDto).Result;
            foreignKeys.ReleaseGroupId = releaseGroupId;
            var entityId = repository.AddFundingAllocation(fundingAllocationDto, foreignKeys).Result;

            return Tuple.Create(fundingAllocationDto, entityId);
        }

        private static void ClearDownCrmFundingAllocation(string fundingId, string restApiUrl, string accessToken)
        {
            var fundingAllocationIdsToRemove = GetFundingAllocationIds(fundingId, restApiUrl, accessToken).ToList();

            fundingAllocationIdsToRemove.ForEach(fundingAllocationId => DeleteCrmFundingAllocation(fundingAllocationId, restApiUrl, accessToken));
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

        private static IReadOnlyCollection<string> GetFundingAllocationIds(string sfaName, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_fundingallocations?$filter=sfa_name eq '{sfaName}'";

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(api).Result;

                Assert.IsTrue(response.IsSuccessStatusCode, $"CRM rest api call to get FundingAllocations for sfa_name: {sfaName} failed");

                var content = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return content["value"].Select(seq => seq["sfa_fundingallocationid"]).Values<string>().ToList();
            }
        }

        private static FundingAllocationDto PopulateFundingAllocationDto(string ukprn, string fundingId)
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

        private string GetUkprnFromAccountTable(string accessToken, string restApiUrl)
        {
            var url = $"{restApiUrl}accounts?$select=name,sfa_ukprn&$top=1&$filter=sfa_ukprn ne null";
            var content = HttpGet(url, accessToken);

            return (string)content["value"][0]["sfa_ukprn"];
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