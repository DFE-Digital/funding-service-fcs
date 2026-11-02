namespace FundingAllocation.Tests.Endpoints.ReleaseGroupSetToReleased.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using System.Text;
    using FundingAllocation.Endpoints.ReleaseGroupSetToReleased.Repositories;

    [TestClass]
    public class CrmReleaseGroupRepositoryTests
    {
        private const string CrmReleaseGroupTableName = "sfa_releasegroups";

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmReleaseGroupRepositoryTests_SetToReleased_ShouldSetReleaseStatusToReleased()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            const string releaseGroupName = "SetToReleasedTest_ReleaseGroupName";
            ClearDownCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);
            var crmEntityId= CreateCrmReleaseGroupAndReturnCrmEntityId(releaseGroupName, restApiUrl, accessToken);

            var repository = new CrmReleaseGroupRepository(appConfiguration);

            // act
            repository.SetToReleased(crmEntityId).Wait();

            // assert
            var updatedReleaseGroup = GetCrmReleaseGroup(releaseGroupName, restApiUrl, accessToken);

            Assert.AreEqual((int)sfa_ReleaseGroupStatus.Released, (int)updatedReleaseGroup["sfa_releasestatus"], "Expected CRM ReleaseGroup Release Status is incorrect");
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

        private static Guid GetEntityId(string oDataEntityId)
        {
            var idWWithClosedBracket = oDataEntityId.Split('(');
            var entityId = idWWithClosedBracket[1].Split(')')[0].ToUpper();
            return new Guid(entityId);
        }

        private static JToken GetCrmReleaseGroup(string sfaName, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}{CrmReleaseGroupTableName}?$filter=sfa_name eq '{sfaName}'";

            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
                var response = httpClient.GetAsync(api).Result;

                Assert.IsTrue(response.IsSuccessStatusCode, "CRM rest api call to get ReleaseGroup failed");

                var content = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

                return content["value"].First;
            }
        }
    }
}