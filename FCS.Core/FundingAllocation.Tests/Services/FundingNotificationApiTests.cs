namespace FundingAllocation.Tests.Services
{
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingNotificationApiTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingNotificationApi_GetNumberOfLatestPage_ShouldGetNumber()
        {
            FundingNotificationApi fundingNotificationApi = new FundingNotificationApi(AppConfiguration.Configuration());
            var x = fundingNotificationApi.GetLatestPageData().Result;
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingNotificationApi_GetProviderFundingAllocation()
        {
            FundingNotificationApi fundingNotificationApi = new FundingNotificationApi(ConfigureFeedSettings());
            var x = fundingNotificationApi.GetProviderFundingAllocation("NMSS-AY-2122-10016972-2_0").Result;
        }


        [TestMethod, TestCategory("TechnicalExploration")]
        public void FundingNotificationApi_GetPage()
        {
            FundingNotificationApi fundingNotificationApi = new FundingNotificationApi(ConfigureFeedSettings());
            var x = fundingNotificationApi.GetPage(2).Result;
        }


        //private static IConfigurationRoot ConfigureFeedSettings()
        //{
        //    IConfigurationRoot configuration = AppConfiguration.Configuration();

        //    configuration["CFS:RootUrl"] = "https://app-t1pp-external-v2.azurewebsites.net";
        //    configuration["CFS:Tenant"] = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
        //    configuration["CFS:ClientId"] = "2aa50637-ee68-4ae1-887f-920511f8e95c";
        //    configuration["CFS:ClientSecret"] = "DEV-OPS to provide";
        //    configuration["CFS:Scope"] = "https://calculatefundingserviceapipreprod/.default";

        //    return configuration;
        //}

        //change is for ConfigureFeedSettings() for CFS-FCS sandbox testing//
        private static IConfigurationRoot ConfigureFeedSettings()
        {
            IConfigurationRoot configuration = AppConfiguration.Configuration();

            configuration["CFS:RootUrl"] = "https://app-t1sb-external-v2.azurewebsites.net";
            configuration["CFS:Tenant"] = "fad277c9-c60a-4da1-b5f3-b3b8b34a82f9";
            configuration["CFS:ClientId"] = "2aa50637-ee68-4ae1-887f-920511f8e95c";
            configuration["CFS:ClientSecret"] = "DEV-OPS to provide";
            configuration["CFS:Scope"] = "https://calculatefundingserviceapipreprod/.default";

            return configuration;
        }
    }
}
