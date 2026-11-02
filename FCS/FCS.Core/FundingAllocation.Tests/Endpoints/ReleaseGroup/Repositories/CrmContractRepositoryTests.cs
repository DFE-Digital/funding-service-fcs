namespace FundingAllocation.Tests.Endpoints.ReleaseGroup.Repositories
{
    using System;
    using System.Linq;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using FluentAssertions;
    using FundingAllocation.Infrastructure;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class CrmContractRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusInfosForUkprn_ShouldReturnRowsWhenContractsFound()
        {
            // arrange
            const string masterContractNumber = "master CN11";
            const string contractNumber = "some CN11";
            const int version = 1;
            const int subVersion = 0;
            var amendmentType = sfa_amendmenttype.Variation;

            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            
            DeleteContracts(masterContractNumber, restApiUrl, accessToken);
            DeleteContracts(contractNumber, restApiUrl, accessToken);
            var provider = GetProviderId(restApiUrl, accessToken);
            DeleteContractsForUkprn(provider.ukprn, restApiUrl, accessToken);
            var fundingType = GetFundingTypeId(restApiUrl, accessToken);
            var fundingPeriod = GetFundingPeriodId(restApiUrl, accessToken);

            var masterContractId = CreateMasterContract(masterContractNumber, provider.providerId, provider.ukprn, restApiUrl, accessToken);
            
            var crmContractEntityId1 = CreateContract(contractNumber, version, subVersion, provider.providerId, provider.ukprn, fundingType.id, fundingPeriod.id, restApiUrl, accessToken, true, amendmentType, masterContractId);

            System.Threading.Thread.Sleep(TimeSpan.FromSeconds(1));
            
            var crmContractEntityId2 = CreateContract(contractNumber, version + 1, subVersion, provider.providerId, provider.ukprn, fundingType.id, fundingPeriod.id, restApiUrl, accessToken, false, amendmentType, masterContractId);

            SetContractToNotLatest(crmContractEntityId1, sfa_contractstatus.Approved, restApiUrl, accessToken);

            var repository = new CrmContractRepository(appConfiguration, GetMockedHttpClientFactory());

            // act
            var crmContractStatusInfos = repository.GetContractStatusInfosForUkprn(int.Parse(provider.ukprn), fundingType.code).Result;

            // assert
            crmContractStatusInfos.Count.Should().Be(2);
            var approvedContract = crmContractStatusInfos.Single(csi => csi.Version == version && csi.SubVersion == 0);
            approvedContract.Should().NotBeNull();
            approvedContract.Number.Should().Be(contractNumber);
            approvedContract.Status.Should().Be("Approved");
            approvedContract.LatestVersion.Should().Be(false);
            approvedContract.CrmEntityId.Should().Be(crmContractEntityId1);
            approvedContract.MasterContractNumber.Should().Be(masterContractNumber);
            approvedContract.LastApprovedVersion.Should().BeTrue();
            approvedContract.FundingPeriod.Should().Be(fundingPeriod.code);
            approvedContract.FundingType.Should().Be(fundingType.code);
            approvedContract.AmendmentType.Should().Be(amendmentType.ToString());

            var draftContract = crmContractStatusInfos.Single(csi => csi.Version == version + 1 && csi.SubVersion == 0);
            draftContract.Should().NotBeNull();
            draftContract.Number.Should().Be(contractNumber);
            draftContract.Status.Should().Be("Draft");
            draftContract.LatestVersion.Should().Be(true);
            draftContract.CrmEntityId.Should().Be(crmContractEntityId2);
            draftContract.MasterContractNumber.Should().Be(masterContractNumber);
            approvedContract.FundingPeriod.Should().Be(fundingPeriod.code);
            approvedContract.FundingType.Should().Be(fundingType.code);

            approvedContract.CreatedDate.Should().BeBefore(draftContract.CreatedDate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusInfosForUkprn_ShouldReturnRowWhenAmendmentTypeIsNull()
        {
            // arrange
            const string masterContractNumber = "master CN11";
            const string contractNumber = "some CN11";
            const int version = 1;
            const int subVersion = 0;
            sfa_amendmenttype? amendmentType = null;

            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            DeleteContracts(masterContractNumber, restApiUrl, accessToken);
            DeleteContracts(contractNumber, restApiUrl, accessToken);
            var provider = GetProviderId(restApiUrl, accessToken);
            DeleteContractsForUkprn(provider.ukprn, restApiUrl, accessToken);
            var fundingType = GetFundingTypeId(restApiUrl, accessToken);
            var fundingPeriod = GetFundingPeriodId(restApiUrl, accessToken);

            var masterContractId = CreateMasterContract(masterContractNumber, provider.providerId, provider.ukprn, restApiUrl, accessToken);

            var crmContractEntityId1 = CreateContract(contractNumber, version, subVersion, provider.providerId, provider.ukprn, fundingType.id, fundingPeriod.id, restApiUrl, accessToken, true, amendmentType, masterContractId);

            System.Threading.Thread.Sleep(TimeSpan.FromSeconds(1));

            var crmContractEntityId2 = CreateContract(contractNumber, version + 1, subVersion, provider.providerId, provider.ukprn, fundingType.id, fundingPeriod.id, restApiUrl, accessToken, false, amendmentType, masterContractId);

            SetContractToNotLatest(crmContractEntityId1, sfa_contractstatus.Approved, restApiUrl, accessToken);

            var repository = new CrmContractRepository(appConfiguration, GetMockedHttpClientFactory());

            // act
            var crmContractStatusInfos = repository.GetContractStatusInfosForUkprn(int.Parse(provider.ukprn), fundingType.code).Result;

            // assert
            crmContractStatusInfos.Count.Should().Be(2);
            var approvedContract = crmContractStatusInfos.Single(csi => csi.Version == version && csi.SubVersion == 0);
            approvedContract.AmendmentType.Should().Be(string.Empty);

            var draftContract = crmContractStatusInfos.Single(csi => csi.Version == version + 1 && csi.SubVersion == 0);
            draftContract.Should().NotBeNull();
            draftContract.AmendmentType.Should().Be(string.Empty);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetContractStatusInfosForUkprn_ShouldReturnNoRowsWhenNoContractsFound()
        {
            // arrange
            const string contractNumber = "some CN11";

            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            DeleteContracts(contractNumber, restApiUrl, accessToken);
            var provider = GetProviderId(restApiUrl, accessToken);
            DeleteContractsForUkprn(provider.ukprn, restApiUrl, accessToken);
            var fundingType = GetFundingTypeId(restApiUrl, accessToken);
            var fundingPeriod = GetFundingPeriodId(restApiUrl, accessToken);

            var repository = new CrmContractRepository(appConfiguration, GetMockedHttpClientFactory());

            // act
            var crmContractStatusInfos = repository.GetContractStatusInfosForUkprn(int.Parse(provider.ukprn), fundingType.code).Result;

            // assert
            crmContractStatusInfos.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmContractRepository_GetAllocationInfosForContractEntityId_ShouldReturnCrmAllocationInfos()
        {
            // arrange
            const string contractNumber = "some CN13";
            const int version = 1;
            const int subVersion = 0;
            const string allocationNumber1 = "Alloc1";
            const string allocationNumber2 = "Alloc2";
            const string fundingStreamCode = "1619ED";
            var amendmentType = sfa_amendmenttype.Notification;

            IConfigurationRoot appConfiguration = AppConfiguration.Configuration();
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";

            DeleteContracts(contractNumber, restApiUrl, accessToken);
            var provider = GetProviderId(restApiUrl, accessToken);
            DeleteContractsForUkprn(provider.ukprn, restApiUrl, accessToken);
            var fundingType = GetFundingTypeId(restApiUrl, accessToken);
            var fundingPeriod = GetFundingPeriodId(restApiUrl, accessToken);

            var crmContractEntityId = CreateContract(contractNumber, version, subVersion, provider.providerId, provider.ukprn, fundingType.id, fundingPeriod.id, restApiUrl, accessToken, false, amendmentType);

            CreateAllocation(allocationNumber1, provider.providerId, provider.ukprn, "1619ED", crmContractEntityId.ToUpper(), restApiUrl, accessToken);
            CreateAllocation(allocationNumber2, provider.providerId, provider.ukprn, "1619ED", crmContractEntityId.ToUpper(), restApiUrl, accessToken);

            var repository = new CrmContractRepository(appConfiguration, GetMockedHttpClientFactory());

            // act
            var crmContractInfos = repository.GetAllocationInfosForContractEntityId(crmContractEntityId).Result;

            // assert
            crmContractInfos.Count.Should().Be(2);
            var firstCrmAllocationInfo = crmContractInfos.SingleOrDefault(cai => cai.AllocationNumber == allocationNumber1);
            firstCrmAllocationInfo.Should().NotBeNull();
            firstCrmAllocationInfo.DeliveryOrgUkprn.Should().Be(provider.ukprn);
            firstCrmAllocationInfo.FundingStreamCode.Should().Be(fundingStreamCode);

            var secondCrmAllocationInfo = crmContractInfos.SingleOrDefault(cai => cai.AllocationNumber == allocationNumber2);
            secondCrmAllocationInfo.Should().NotBeNull();
            secondCrmAllocationInfo.DeliveryOrgUkprn.Should().Be(provider.ukprn);
            secondCrmAllocationInfo.FundingStreamCode.Should().Be(fundingStreamCode);
        }

        private string CreateMasterContract(string contractNumber, string providerId, string ukprn, string restApiUrl, string accessToken)
        {

            var crmContract =
                new JObject(
                    new JProperty("sfa_number", contractNumber),
                    new JProperty("sfa_ProviderName@odata.bind", $"/accounts({providerId})"),
                    new JProperty("sfa_ukprn", ukprn)
                );

            var destinationUrl = $"{restApiUrl}/sfa_contracts";

            var request = new HttpRequestMessage(HttpMethod.Post, destinationUrl)
            {
                Content = new StringContent(JObject.FromObject(crmContract).ToString(), Encoding.UTF8,
                    "application/json")
            };
            HttpClient httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;

            return GetEntityId(response.Headers.GetValues("OData-EntityId").FirstOrDefault()).ToString();
        }
        
        private string CreateContract(
            string contractNumber,
            in int version,
            in int subVersion,
            string providerId,
            string ukprn,
            string fundingTypeId,
            string fundingPeriodId,
            string restApiUrl,
            string accessToken,
            bool lastApprovedVersion,
            sfa_amendmenttype? amendmentType,
            string masterContractId = default)
        {

            var crmContract =
                new JObject(
                    new JProperty("sfa_number", contractNumber),
                    new JProperty("sfa_version", version),
                    new JProperty("sfa_subversion", subVersion),
                    new JProperty("sfa_ProviderName@odata.bind", $"/accounts({providerId})"),
                    new JProperty("sfa_FundingType@odata.bind", $"/sfa_fundingtypes({fundingTypeId})"),
                    new JProperty("sfa_PeriodId@odata.bind", $"/sfa_periods({fundingPeriodId})"),
                    new JProperty("sfa_ukprn", ukprn),
                    new JProperty("sfa_amendmenttype", amendmentType),
                    new JProperty("sfa_lastapprovedversion", lastApprovedVersion));

            if (masterContractId != null)
            {
                crmContract.Add(new JProperty("sfa_ParentContractId@odata.bind", $"/sfa_contracts({masterContractId})"));
            }

            var destinationUrl = $"{restApiUrl}/sfa_contracts";

            var request = new HttpRequestMessage(HttpMethod.Post, destinationUrl)
            {
                Content = new StringContent(JObject.FromObject(crmContract).ToString(), Encoding.UTF8,
                    "application/json")
            };
            HttpClient httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;

            var entityId = GetEntityId(response.Headers.GetValues("OData-EntityId").FirstOrDefault()).ToString();

            return entityId;
        }

        private void SetContractToNotLatest(string crmEntityId, sfa_contractstatus contractStatus, string restApiUrl, string accessToken)
        {
            var crmContract = new JObject(
                new JProperty("sfa_latestversion", false),
                new JProperty("sfa_contractstatus", contractStatus)
            );
            var destinationUrl = $"{restApiUrl}/sfa_contracts({crmEntityId})";

            var request = new HttpRequestMessage(HttpMethod.Patch, destinationUrl)
            {
                Content = new StringContent(JObject.FromObject(crmContract).ToString(), Encoding.UTF8,
                    "application/json")
            };
            HttpClient httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
        }

        private void SetContractAmendmentType(string crmEntityId, sfa_amendmenttype amendmentType, string restApiUrl, string accessToken)
        {
            var crmContract = new JObject(
                new JProperty("sfa_amendmenttype", amendmentType)
            );
            var destinationUrl = $"{restApiUrl}/sfa_contracts({crmEntityId})";

            var request = new HttpRequestMessage(HttpMethod.Patch, destinationUrl)
            {
                Content = new StringContent(JObject.FromObject(crmContract).ToString(), Encoding.UTF8,
                    "application/json")
            };
            HttpClient httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
        }

        private void CreateAllocation(string allocationNumber, string providerId, string ukprn, string fundingStreamCode, string crmContractEntityId, string restApiUrl, string accessToken)
        {
            var sfa_fundingstreamid = GetFundingStreamEntityReference(restApiUrl, accessToken, fundingStreamCode);

            var crmAllocation =
                 new JObject(
                     new JProperty("sfa_contractallocationnumber", allocationNumber),
                     new JProperty("sfa_FundingStreamId@odata.bind", $"/sfa_fundingstreams({sfa_fundingstreamid})"),
                     new JProperty("sfa_deliveryorganisationprovider@odata.bind", $"/accounts({providerId})"),
                     new JProperty("sfa_deliveryorganisationukprn", ukprn),
                     new JProperty("sfa_ContractId@odata.bind", $"/sfa_contracts({crmContractEntityId})")
                 );

            var destinationUrl = $"{restApiUrl}/sfa_contractallocations";

            var request = new HttpRequestMessage(HttpMethod.Post, destinationUrl)
            {
                Content = new StringContent(JObject.FromObject(crmAllocation).ToString(), Encoding.UTF8,
                    "application/json")
            };
            HttpClient httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.SendAsync(request).Result;
        }

        private (string providerId, string ukprn) GetProviderId(string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}accounts?$select=accountid,sfa_ukprn&$top=1&$filter=sfa_ukprn ne null";

            using var httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => (row["accountid"].ToString(), row["sfa_ukprn"].ToString())).Single();
        }

        private (string id, string code) GetFundingTypeId(string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_fundingtypes?$select=sfa_fundingtypeid,sfa_fundingtypecode&$top=1";

            using var httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => (row["sfa_fundingtypeid"].ToString(), row["sfa_fundingtypecode"].ToString())).Single();
        }

        private (string id, string code) GetFundingPeriodId(string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_periods?$select=sfa_periodid, sfa_periodname&$top=1";

            using var httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

            var response = httpClient.GetAsync(api).Result;

            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);

            return jObject["value"].Select(row => (row["sfa_periodid"].ToString(), row["sfa_periodname"].ToString())).Single();
        }

        private static void DeleteContracts(string contractNumber, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_contracts?$filter=sfa_number eq '{contractNumber}'";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;
            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);
            var contractIds = jObject["value"].Select(row => row["sfa_contractid"].ToString()).ToList();

            contractIds.ForEach(contractId =>
            {
                var api = $"{restApiUrl}sfa_contracts({contractId})";

                using var httpClient = new HttpClient();
                var request = new HttpRequestMessage(HttpMethod.Delete, api);
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                httpClient.SendAsync(request).Wait();
            });
        }

        private static void DeleteContractsForUkprn(string ukprn, string restApiUrl, string accessToken)
        {
            var api = $"{restApiUrl}sfa_contracts?$filter=sfa_ukprn eq '{ukprn}'";

            using var httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);
            var response = httpClient.GetAsync(api).Result;
            var jObject = (JObject)JsonConvert.DeserializeObject(response.Content.ReadAsStringAsync().Result);
            var contractIds = jObject["value"].Select(row => row["sfa_contractid"].ToString()).ToList();

            contractIds.ForEach(contractId =>
            {
                var api = $"{restApiUrl}sfa_contracts({contractId})";

                using var httpClient = new HttpClient();
                var request = new HttpRequestMessage(HttpMethod.Delete, api);
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("bearer", accessToken);

                httpClient.SendAsync(request).Wait();
            });
        }

        private static Guid GetEntityId(string oDataEntityId)
        {
            var idWWithClosedBracket = oDataEntityId.Split('(');
            var entityId = idWWithClosedBracket[1].Split(')')[0].ToUpper();
            return new Guid(entityId);
        }

        private string GetFundingStreamEntityReference(string restApiUrl, string accessToken, string fundingStreamCode)
        {
            var httpClient = new HttpClient();

            var url = $"{restApiUrl}sfa_fundingstreams?$select=sfa_fundingstreamid&$top=1&$filter=sfa_fundingstreamcode eq '{fundingStreamCode}'";
            var content = CrmHttpApiCaller.HttpGet(url, httpClient, accessToken);

            var entityId = (string)content["value"][0]["sfa_fundingstreamid"];
            return entityId.ToUpper();
        }

        private IHttpClientFactory GetMockedHttpClientFactory()
        {
            Mock<IHttpClientFactory> httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(m => m.CreateClient(It.IsAny<string>())).Returns(new HttpClient());

            return httpClientFactoryMock.Object;
        }
    }
}
