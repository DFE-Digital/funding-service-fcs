namespace FundingAllocation.Tests.Endpoints.UpdateFundingAllocation
{
    using System;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using FundingAllocation.Endpoints.UpdateFundingAllocation;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using FluentAssertions;

    [TestClass]
    public class CrmUpdateFundingAllocationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmFundingAllocationReturnToSchedulingRepository_Update_SetFundingAllocationToReturnedToScheduling()
        {
            // arrange
            const string fundingId = "SomeFundingId5";
            const string contractNumber = "some CN23";
            const string contractVersion = "1";

            var accessToken = AccessToken;
            var restApiUrl = RestUrl;

            string fundingCrmId = GetFundingAllocationId(restApiUrl, accessToken, fundingId);
            if (!string.IsNullOrEmpty(fundingCrmId))
            {
                DeleteCrmFundingAllocation(fundingCrmId, restApiUrl, accessToken);
            }
            var releaseGroupId = GetReleaseGroupId(restApiUrl, accessToken);

            fundingCrmId = CreateFundingAllocation(restApiUrl, accessToken, fundingId, releaseGroupId, contractNumber, contractVersion);

            var fundingAllocationInfo = GetFundingAllocationInfo(restApiUrl, accessToken, fundingId);
            fundingAllocationInfo.releaseGrp.ToUpper().Should().Be(releaseGroupId);
            fundingAllocationInfo.contractNumber.Should().Be(contractNumber);
            fundingAllocationInfo.contractVersion.Should().Be(contractVersion);
            fundingAllocationInfo.status.Should().Be(sfa_FundingAllocationStatus.Released);
            fundingAllocationInfo.subStatus.Should().Be(sfa_FundingAllocationSubStatus.Released);

            var crmFundingAllocationRepository = new CrmUpdateFundingAllocationRepository(AppConfiguration.Configuration());

            // act
            crmFundingAllocationRepository.ReturnToScheduling(fundingCrmId, sfa_FundingAllocationServiceResponse.ContractWithdrawn).Wait();

            // assert
            fundingAllocationInfo = GetFundingAllocationInfo(restApiUrl, accessToken, fundingId);
            fundingAllocationInfo.releaseGrp.ToUpper().Should().BeEmpty();
            fundingAllocationInfo.contractNumber.Should().BeEmpty();
            fundingAllocationInfo.contractVersion.Should().BeEmpty();
            fundingAllocationInfo.status.Should().Be(sfa_FundingAllocationStatus.Scheduling);
            fundingAllocationInfo.subStatus.Should().Be(sfa_FundingAllocationSubStatus.ReturnedtoScheduling);
        }

        private string RestUrl => AppConfiguration.Configuration()["CRM:ResourceId"] + "/api/data/v9.1/";

        private string AccessToken => CrmAccessTokenFactory.GetAccessToken(AppConfiguration.Configuration());

        private static void DeleteCrmFundingAllocation(string fundingCrmId, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_fundingallocations({fundingCrmId})";

            using var httpClient = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Delete, api);
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
            Assert.IsTrue(response.IsSuccessStatusCode, $"Did not delete Funding Allocation: {fundingCrmId}");
        }

        public string GetReleaseGroupId(string restApiUrl, string accessToken)
        {
            var url = $"{restApiUrl}sfa_releasegroups?$select=sfa_releasegroupid&$top=1";
            var content = CrmHttpApiCaller.HttpGet(url, new HttpClient(), accessToken);

            var entityId = (string)content["value"][0]["sfa_releasegroupid"];
            return entityId.ToUpper();
        }

        public string GetFundingAllocationId(string restApiUrl, string accessToken, string fundingId)
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

        private static string CreateFundingAllocation(string restApiUrl, string accessToken, string fundingId, string releaseGrpId, string contractNumber, string contractVersion)
        {
            JObject crmFundingAllocation = new JObject(
                new JProperty("sfa_name", fundingId),
                new JProperty("sfa_releasegroup@odata.bind", $"/sfa_releasegroups({releaseGrpId})"),
                new JProperty("sfa_contract", contractNumber),
                new JProperty("sfa_contractversion", contractVersion),
                new JProperty("sfa_status", sfa_FundingAllocationStatus.Released),
                new JProperty("sfa_substatus", sfa_FundingAllocationSubStatus.Released)
            );

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


        public (string releaseGrp, string contractNumber, string contractVersion, sfa_FundingAllocationStatus status, sfa_FundingAllocationSubStatus subStatus)
            GetFundingAllocationInfo(string restApiUrl, string accessToken, string fundingId)
        {
            var url = $"{restApiUrl}sfa_fundingallocations?$select=_sfa_releasegroup_value,sfa_contract,sfa_contractversion,sfa_substatus,sfa_status" +
                      $"&$top=1&$filter=sfa_name eq '{fundingId}'";

            var content = CrmHttpApiCaller.HttpGet(url, new HttpClient(), accessToken);

            var releaseGrpId = ((JObject)content["value"][0]).GetValueElseNull("_sfa_releasegroup_value")?.ToString();
            var contractNumber = ((JObject)content["value"][0]).GetValueElseNull("sfa_contract")?.ToString();
            var contractVersion = ((JObject)content["value"][0]).GetValueElseNull("sfa_contractversion")?.ToString();
            var statusString = ((JObject)content["value"][0]).GetValueElseNull("sfa_status")?.ToString();
            var status = Enum.Parse<sfa_FundingAllocationStatus>(statusString);
            var subStatusString = ((JObject)content["value"][0]).GetValueElseNull("sfa_substatus")?.ToString();
            var subStatus = Enum.Parse<sfa_FundingAllocationSubStatus>(subStatusString);

            return (releaseGrpId, contractNumber, contractVersion, status, subStatus);
        }
    }
}
