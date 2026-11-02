namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Extensions;
    using FluentAssertions;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmReleaseGroupRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReleaseGroupRepository_ShouldCreate()
        {
            // arrange
            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            const string releaseGrpName = "Test RG";
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var crmPolicyRepository = new CrmPolicyConfigRepository();
            var httpClient = new HttpClient();
            var fundingTypeId =
                crmPolicyRepository.GetFundingTypeEntityReference(restApiUrl, httpClient, accessToken, "EDSK");
            var fundingPeriodId =
                crmPolicyRepository.GetPeriodEntityReference(restApiUrl, httpClient, accessToken, "AY2021");
            var contractTypeId =
                crmPolicyRepository.GetContractTypeId(restApiUrl, httpClient, accessToken, "Non-learning Grant");
            var fspGroupId = crmPolicyRepository.GetFspGroupId(restApiUrl, httpClient, accessToken, "16-19ED2021");
            string releaseGrpId = Guid.NewGuid().ToString();
            CrmReleaseGroupRepository crmReleaseGroupRepository = new CrmReleaseGroupRepository(appConfiguration);
            var ids = GetReleaseGroupIds(restApiUrl, accessToken, contractTypeId).ToList();

            ids.ForEach(id => DeleteCrmReleaseGroup(id, restApiUrl, accessToken));
            // act
            crmReleaseGroupRepository
                .CreateReleaseGroup(releaseGroupName:releaseGrpName, fundingTypeId, fundingPeriodId, fspGroupId, contractTypeId, releaseGrpId).Wait();

            // assert
            var rows = GetReleaseGroups(restApiUrl, releaseGrpId, accessToken);
            Assert.AreEqual(1, rows.Count, "The number of rows returned is not correct");
            var row = rows.First();
            Assert.AreEqual(fundingTypeId, row.fundingTypeId.ToUpper(), "The FundingType is not correct");
            Assert.AreEqual(fundingPeriodId, row.fundingPeriodId.ToUpper(), "The FundingPeriod is not correct");
            Assert.AreEqual(contractTypeId, row.contractTypeId.ToUpper(), "The ContractType is not correct");
            Assert.AreEqual(fspGroupId, row.fspGroupId.ToUpper(), "The FspGroup is not correct");
            Assert.AreEqual(releaseGrpName, row.releaseGrpName, "The releaseGrpName is not correct");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ClearFundingAllocationAndReleaseGroups()
        {
            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            var fundingAllocationIds = GetFundingAllocationIds(restApiUrl, accessToken);
            var releaseGroupIds = GetReleaseGroupIds(restApiUrl, accessToken);

            fundingAllocationIds.ToList().ForEach(id => DeleteCrmFundingAllocation(id, restApiUrl, accessToken));
            releaseGroupIds.ToList().ForEach(id => DeleteCrmReleaseGroup(id, restApiUrl, accessToken));
        }

        private static IReadOnlyCollection<(string releaseGrpName, string contractTypeId, string fspGroupId, string fundingPeriodId, string fundingTypeId)> GetReleaseGroups(string restApiUrl, string releaseGrpId, string accessToken)
        {
            var api = $"{restApiUrl}sfa_releasegroups?$filter=sfa_releasegroupid eq '{releaseGrpId}'";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;

            Assert.IsTrue(response.IsSuccessStatusCode, $"CRM rest api failed");

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => (
                row["sfa_name"].ToString(),
                row["_sfa_contracttype_value"].ToString(),
                row["_sfa_fspgroup_value"].ToString(),
                row["_sfa_fundingperiod_value"].ToString(),
                row["_sfa_fundingtype_value"].ToString()
            )).ToList();
        }

        private static IReadOnlyCollection<string> GetReleaseGroupIds(string restApiUrl, string accessToken, string contractTypeId)
        {
            var api = $"{restApiUrl}sfa_releasegroups?$filter=_sfa_contracttype_value eq {contractTypeId}";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => row["sfa_releasegroupid"].ToString()).ToList();
        }

        private static IReadOnlyCollection<string> GetFundingAllocationIds(string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_fundingallocations";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => row["sfa_fundingallocationid"].ToString()).ToList();
        }

        private static IReadOnlyCollection<string> GetReleaseGroupIds(string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_releasegroups";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => row["sfa_releasegroupid"].ToString()).ToList();
        }
        
        private static void DeleteCrmReleaseGroup(string releaseGrpId, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_releasegroups({releaseGrpId})";

            using var httpClient = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Delete, api);
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
            Assert.IsTrue(response.IsSuccessStatusCode, "Did not delete ReleaseGrp");
        }

        private static void DeleteCrmFundingAllocation(string fundingAllocationId, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_fundingallocations({fundingAllocationId})";

            using var httpClient = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Delete, api);
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
            Assert.IsTrue(response.IsSuccessStatusCode, "Did not delete ReleaseGrp");
        }
    }
}
