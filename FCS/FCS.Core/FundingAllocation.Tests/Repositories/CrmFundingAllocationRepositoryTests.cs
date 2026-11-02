namespace FundingAllocation.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using Extensions;
    using FluentAssertions;
    using FluentAssertions.Extensions;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmFundingAllocationRepositoryTests
    {
        private const string CrmFundingAllocationTableName = "sfa_fundingallocations";
        private const string CrmReleaseGroupTableName = "sfa_releasegroups";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationRepository_Update_ShouldUpdateWithNullReleaseGroup()
        {
            // arrange
            const string releaseGroupName = "CrmFundingAllocationRepository_Update_ReleaseGroupNull";
            const string fundingId = "CrmFundingAllocationRepository_Update_ReleaseGroupNull";
            var appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            ClearDownCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);
            var releaseGroupId = CreateCrmReleaseGroupAndReturnCrmEntityId(releaseGroupName, restApiUrl, accessToken);

            ClearDownCrmFundingAllocation(fundingId, restApiUrl, accessToken);
            var fundingCrmId = CreateFundingAllocationAndReturnCrmEntityId(restApiUrl, accessToken, fundingId, releaseGroupId);

            var crmFundingAllocationRepository = new CrmFundingAllocationRepository(appConfiguration, Mock.Of<ICrmPolicyConfigRepository>(), Mock.Of<ICrmProviderRepository>());

            // act
            crmFundingAllocationRepository.Update(fundingCrmId, null, sfa_FundingAllocationServiceResponse.Hold).Wait();

            // assert
            var fundingAllocationInfo = GetFundingAllocationReleaseGroupIdAndSubstatus(restApiUrl, accessToken, fundingId);
            fundingAllocationInfo.releaseGrp.Should().BeEmpty();
            fundingAllocationInfo.subStatus.Should().Be(sfa_FundingAllocationSubStatus.Held);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationRepository_Update_ShouldUpdateWithReleaseGroup()
        {
            // arrange
            const string releaseGroupName = "CrmFundingAllocationRepository_Update_ReleaseGroupValue";
            const string fundingId = "CrmFundingAllocationRepository_Update_ReleaseGroupValue";
            var appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            ClearDownCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);
            var releaseGroupId = CreateCrmReleaseGroupAndReturnCrmEntityId(releaseGroupName, restApiUrl, accessToken);

            ClearDownCrmFundingAllocation(fundingId, restApiUrl, accessToken);
            var fundingCrmId = CreateFundingAllocationAndReturnCrmEntityId(restApiUrl, accessToken, fundingId, releaseGroupId);

            var crmFundingAllocationRepository = new CrmFundingAllocationRepository(appConfiguration, Mock.Of<ICrmPolicyConfigRepository>(), Mock.Of<ICrmProviderRepository>());

            // act
            crmFundingAllocationRepository.Update(fundingCrmId, releaseGroupId, sfa_FundingAllocationServiceResponse.ReleasefromHold).Wait();

            // assert
            var fundingAllocationInfo = GetFundingAllocationReleaseGroupIdAndSubstatus(restApiUrl, accessToken, fundingId);
            fundingAllocationInfo.releaseGrp.ToUpper().Should().Be(releaseGroupId);
            fundingAllocationInfo.subStatus.Should().Be(sfa_FundingAllocationSubStatus.AwaitingRelease);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationRepository_SetToQueued_ShouldUpdateStatusSubStatusQueuedOnAndQueuedDueToContract()
        {
            // arrange
            const string fundingId = "CrmFundingAllocationRepository_SetToQueued";
            const string contractNumber = "ContractNo_SetToQueued";
            var now = DateTime.Now.AsUtc();
            var appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            ClearDownCrmFundingAllocation(fundingId, restApiUrl, accessToken);
            var fundingCrmId = CreateFundingAllocationAndReturnCrmEntityId(restApiUrl, accessToken, fundingId, null);

            var crmFundingAllocationRepository = new CrmFundingAllocationRepository(appConfiguration,
                Mock.Of<ICrmPolicyConfigRepository>(),
                Mock.Of<ICrmProviderRepository>());

            // act
            crmFundingAllocationRepository.SetToQueued(fundingCrmId, contractNumber, now).Wait();

            // assert
            var (status, subStatus, queuedOn, queuedDueToContract) = 
                GetFundingAllocationStatusSubstatusQueuedOnAndQueuedDueToContract(restApiUrl, accessToken, fundingId);
            status.Should().Be(sfa_FundingAllocationStatus.InRelease);
            subStatus.Should().Be(sfa_FundingAllocationSubStatus.Queued);
            queuedOn.AreEqualIgnoreMilliseconds(now).Should().BeTrue();
            queuedDueToContract.Should().Be(contractNumber);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationRepository_ClearQueued_ShouldClearQueuedOnAndQueuedDueToContract()
        {
            // arrange
            const string fundingId = "CrmFundingAllocationRepository_ClearQueued";
            const string contractNumber = "ContractNo_ClearQueued";
            var now = DateTime.Now.AsUtc();
            var appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            ClearDownCrmFundingAllocation(fundingId, restApiUrl, accessToken);
            var fundingCrmId = CreateFundingAllocationAndReturnCrmEntityId(restApiUrl, accessToken, fundingId, null);

            var crmFundingAllocationRepository = new CrmFundingAllocationRepository(appConfiguration,
                Mock.Of<ICrmPolicyConfigRepository>(),
                Mock.Of<ICrmProviderRepository>());

            crmFundingAllocationRepository.SetToQueued(fundingCrmId, contractNumber, now).Wait();

            var setUpTuples =
                GetFundingAllocationStatusSubstatusQueuedOnAndQueuedDueToContract(restApiUrl, accessToken, fundingId);
            setUpTuples.status.Should().Be(sfa_FundingAllocationStatus.InRelease);
            setUpTuples.subStatus.Should().Be(sfa_FundingAllocationSubStatus.Queued);
            setUpTuples.queuedOn.AreEqualIgnoreMilliseconds(now).Should().BeTrue();
            setUpTuples.queuedDueToContract.Should().Be(contractNumber);

            // act
            crmFundingAllocationRepository.ClearQueued(fundingCrmId).Wait();

            // assert
            var (status, subStatus, queuedOn, queuedDueToContract) =
                GetFundingAllocationStatusSubstatusQueuedOnAndQueuedDueToContract(restApiUrl, accessToken, fundingId);
            status.Should().Be(sfa_FundingAllocationStatus.InRelease);
            subStatus.Should().Be(sfa_FundingAllocationSubStatus.Queued);
            queuedOn.Should().Be(null);
            queuedDueToContract.Should().Be(string.Empty);
        }

        private static void ClearDownCrmReleaseGroup(string releaseGroupId, string restApiUrl, string accessToken)
        {
            var releaseGroupIdsToRemove = GetReleaseGroupIds(releaseGroupId, restApiUrl, accessToken).ToList();

            releaseGroupIdsToRemove.ForEach(crmReleaseGroupId => DeleteCrmReleaseGroup(crmReleaseGroupId, restApiUrl, accessToken));
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

        private static string CreateCrmReleaseGroupAndReturnCrmEntityId(string releaseGroupName, string restApiUrl, string accessToken)
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

        private static void ClearDownCrmFundingAllocation(string fundingId, string restApiUrl, string accessToken)
        {
            var fundingAllocationIdsToRemove = GetFundingAllocationIds(fundingId, restApiUrl, accessToken).ToList();

            fundingAllocationIdsToRemove.ForEach(fundingAllocationId => DeleteCrmFundingAllocation(fundingAllocationId, restApiUrl, accessToken));
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

        private static void DeleteCrmFundingAllocation(string fundingCrmId, string restApiUrl, string accessToken)
        {
            if (!string.IsNullOrEmpty(fundingCrmId))
            {
                var api = $"{restApiUrl}{CrmFundingAllocationTableName}({fundingCrmId})";

                using (var httpClient = new HttpClient())
                {
                    var request = new HttpRequestMessage(HttpMethod.Delete, api);
                    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                    var response = httpClient.SendAsync(request).Result;
                    Assert.IsTrue(response.IsSuccessStatusCode, $"Did not delete Funding Allocation: {fundingCrmId}");
                }
            }
        }

        private static string GetFundingAllocationId(string restApiUrl, string accessToken, string fundingId)
        {
            var url = $"{restApiUrl}sfa_fundingallocations?$select=sfa_fundingallocationid&$top=1&$filter=sfa_name eq '{fundingId}'";
            var content = CrmHttpApiCaller.HttpGet(url, new HttpClient(), accessToken);

            var value = content["value"];
            if (value.Length() > 0)
            {
                var entityId = (string)content["value"][0]["sfa_fundingallocationid"];
                return entityId.ToUpper();
            }

            return string.Empty;
        }

        private static string CreateFundingAllocationAndReturnCrmEntityId(string restApiUrl, string accessToken, string fundingId, string releaseGrpId)
        {
            JObject crmFundingAllocation = new JObject(
                new JProperty("sfa_name", fundingId),
                new JProperty("sfa_releasegroup@odata.bind", $"/sfa_releasegroups({releaseGrpId})"));

            if (releaseGrpId == null)
            {
                crmFundingAllocation = new JObject(
                    new JProperty("sfa_name", fundingId));
            }

            var destination = $"{restApiUrl}sfa_fundingallocations";
            var httpClient = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Post, destination)
            {
                Content = new StringContent(JObject.FromObject(crmFundingAllocation).ToString(), Encoding.UTF8,
                    "application/json")
            };

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
            var urlOfNewEntity = response.Headers.GetValues("OData-EntityId").First();

            var entityId = urlOfNewEntity.Split("sfa_fundingallocations(").Last()[..^1];

            return entityId;
        }

        private (string releaseGrp, sfa_FundingAllocationSubStatus subStatus) GetFundingAllocationReleaseGroupIdAndSubstatus(string restApiUrl, string accessToken, string fundingId)
        {
            var url = $"{restApiUrl}sfa_fundingallocations?$select=_sfa_releasegroup_value,sfa_substatus&$top=1&$filter=sfa_name eq '{fundingId}'";
            var content = CrmHttpApiCaller.HttpGet(url, new HttpClient(), accessToken);

            var releaseGrpId = ((JObject)content["value"][0]).GetValueElseNull("_sfa_releasegroup_value")?.ToString();
            var subStatusString = ((JObject)content["value"][0]).GetValueElseNull("sfa_substatus")?.ToString();
            var subStatus = Enum.Parse<sfa_FundingAllocationSubStatus>(subStatusString);

            return (releaseGrpId, subStatus);
        }

        private static (sfa_FundingAllocationStatus status, sfa_FundingAllocationSubStatus subStatus, DateTime? queuedOn, string queuedDueToContract) 
            GetFundingAllocationStatusSubstatusQueuedOnAndQueuedDueToContract(string restApiUrl, string accessToken, string fundingId)
        {
            var url = $"{restApiUrl}sfa_fundingallocations?$select=sfa_status,sfa_substatus,sfa_queuedon,sfa_queuedduetocontract&$top=1&$filter=sfa_name eq '{fundingId}'";
            var content = CrmHttpApiCaller.HttpGet(url, new HttpClient(), accessToken);

            var queuedOnString = ((JObject)content["value"][0]).GetValueElseNull("sfa_queuedon")?.ToString(); 
            var queuedDueToContract = ((JObject)content["value"][0]).GetValueElseNull("sfa_queuedduetocontract")?.ToString();
            var statusString = ((JObject)content["value"][0]).GetValueElseNull("sfa_status")?.ToString();
            var subStatusString = ((JObject)content["value"][0]).GetValueElseNull("sfa_substatus")?.ToString();
            var status = Enum.Parse<sfa_FundingAllocationStatus>(statusString ?? string.Empty);
            var subStatus = Enum.Parse<sfa_FundingAllocationSubStatus>(subStatusString ?? string.Empty);

            var queuedOn = string.IsNullOrEmpty(queuedOnString) ? (DateTime?)null : DateTime.Parse(queuedOnString);
            return (status, subStatus, queuedOn, queuedDueToContract);
        }

        private static Guid GetEntityId(string oDataEntityId)
        {
            var idWWithClosedBracket = oDataEntityId.Split('(');
            var entityId = idWWithClosedBracket[1].Split(')')[0].ToUpper();
            return new Guid(entityId);
        }
    }
}