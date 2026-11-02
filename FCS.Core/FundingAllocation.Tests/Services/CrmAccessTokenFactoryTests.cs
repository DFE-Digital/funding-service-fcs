namespace FundingAllocation.Tests.Services
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Threading.Tasks;
    using FundingAllocation.Services;

    [TestClass]
    public class CrmAccessTokenFactoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmAccessTokenFactory_GetAccessTokenFromCache_CheckCacheIsInvalidatedInLineWithAbsoluteExpirationRelativeToNowSetting()
        {
            // arrange 
            var appConfiguration = AppConfiguration.Configuration();

            // act & assert
            // Step through test code and code code.  

            // Within CrmAccessTokenFactory set 
            // cacheEntryOptions.AbsoluteExpirationRelativeToNow = new TimeSpan(0, 0, 0, 5);
            // And step through method - will call http (1st call so there is no cache)
            var accessToken1st = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
            Task.Delay(10000).Wait();

            // Within CrmAccessTokenFactory set 
            // cacheEntryOptions.AbsoluteExpirationRelativeToNow = new TimeSpan(0, 0, 55, 0);
            // And step through method - will call http (cache will have been invalidated after 5 seconds)
            var accessToken2nd = CrmAccessTokenFactory.GetAccessToken(appConfiguration);

            // And step through method - will not call http and returns cache value
            var accessToken3rd = CrmAccessTokenFactory.GetAccessToken(appConfiguration);
        }
    }
}