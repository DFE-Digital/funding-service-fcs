namespace FundingAllocation.Tests.Endpoints.CreateFundingAllocationInCrm.Repositories
{
    using System;
    using System.Linq;
    using System.Net.Http;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Collections.Generic;
    using Extensions;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;

    [TestClass]
    public class CrmPolicyConfigRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetFundingTypeEntityReference_ShouldReturnFundingTypeEntityReference()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var httpClient = new HttpClient();
            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();

            // act
            var response = crmPolicyConfigRepository.GetFundingTypeEntityReference(restApiUrl, httpClient, accessToken, "EDSK");

            // assert 
            Assert.IsTrue(response.HasValue(), "FundingTypeEntityReference was not returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetPeriodEntityReference_ShouldReturnPeriodEntityReference()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var httpClient = new HttpClient();
            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();

            // act
            var response = crmPolicyConfigRepository.GetPeriodEntityReference(restApiUrl, httpClient, accessToken, "AY2021");

            // assert 
            Assert.IsTrue(response.HasValue(), "PeriodEntityReference was not returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetOptionSets_sfa_status_ShouldReturnStatusOptionSetItems()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var httpClient = new HttpClient();
            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();

            // act
            var returnedOptionSets = crmPolicyConfigRepository.GetOptionSets(restApiUrl, httpClient, accessToken, "sfa_status");

            // assert 
            var expectedOptionSetLabels = new List<string> { "Scheduling", "In Release", "Released" };
            var returnedOptionSetLabels = returnedOptionSets.Select(optionSet => optionSet.OptionValueLabel).ToList();

            Assert.IsTrue(expectedOptionSetLabels.All(x => returnedOptionSetLabels.Contains(x)), "Unexpected OptionSets returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetOptionSets_sfa_substatus_ShouldReturnStatusOptionSetItems()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var httpClient = new HttpClient();
            var crmPolicyConfigRepository = new CrmPolicyConfigRepository();

            // act
            var returnedOptionSets = crmPolicyConfigRepository.GetOptionSets(restApiUrl, httpClient, accessToken, "sfa_substatus");

            // assert 
            var expectedOptionSetLabels = new List<string> { "Awaiting Release", "Released" };
            var returnedOptionSetLabels = returnedOptionSets.Select(optionSet => optionSet.OptionValueLabel).ToList();

            Assert.IsTrue(expectedOptionSetLabels.All(x => returnedOptionSetLabels.Contains(x)), "Unexpected OptionSets returned");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetContractTypeId_ShouldReturnId()
        {
            // act
            var crmGuid = GetDataFromCrm(new CrmPolicyConfigRepository().GetContractTypeId, "Non-learning Grant");

            // assert 
            Assert.IsTrue(Guid.TryParse(crmGuid, out Guid g), "The contract type has not been found");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmPolicyConfigRepository_GetFspGroupId_ShouldReturnId()
        {
            // act
            var crmGuid = GetDataFromCrm(new CrmPolicyConfigRepository().GetFspGroupId, "16-19ED2021");

            // assert 
            Assert.IsTrue(Guid.TryParse(crmGuid, out Guid g), "The contract type has not been found");
        }

        private string GetDataFromCrm(Func<string, HttpClient, string, string, string> getConfigRepositoryMethod, string key)
        {
            var appConfiguration = AppConfiguration.Configuration();
            var restApiUrl = appConfiguration["CRM:ResourceId"] + "/api/data/v9.1/";
            var accessToken = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            var httpClient = new HttpClient();

            return getConfigRepositoryMethod(restApiUrl, httpClient, accessToken, key);
        }
    }
}