namespace ContractRequestDomain.EngagementWatcher.Tests.Services
{
    using EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System.Configuration;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;

    [TestClass]
    public class DasEventsApiAdapterConnectivityTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void DasEventsApiAdapter_ShouldConnectToDasEngagementsPreProdApi()
        {
            // arrange 
            const long fromEventId = 1;
            const int pageSize = 100;

            ConfigurationManager.AppSettings["DasEngagements.BaseUrl"] = "https://pp-gateway.apprenticeships.education.gov.uk/";
			ConfigurationManager.AppSettings["DasEngagements.SubscriptionKey"] = "";

			//ConfigurationManager.AppSettings["DasEngagements.ResourceId"] = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
			//ConfigurationManager.AppSettings["DasEngagements.ClientId"] = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
			//ConfigurationManager.AppSettings["DasEngagements.SecretKey"] = "";

			var oAuthAccessTokenFactory = new OAuthAccessTokenFactory();

            // act
            IReadOnlyCollection<EngagementEvent> returnedEvents = new DasEventsApiAdapter(oAuthAccessTokenFactory).GetEngagementEventsAfterId(fromEventId, pageSize);

            // assert
            Assert.IsNotNull(returnedEvents, "GetEngagementEventsAfterId returned no events when calling DasEngagements PreProd API");

            var engagementEvent = returnedEvents.First();
            Assert.IsTrue(engagementEvent.EventId >= fromEventId, "Returned unexpected EventId");
            Assert.IsTrue(engagementEvent.EventType.Length > 0, "Returned EventType in unexpected format");
            Assert.IsTrue(long.Parse(engagementEvent.ProviderId) >= 10000000, "Returned ProviderId in unexpected format");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DasEventsApiAdapter_ShouldClearOauthTokenCacheWhenCachedTokenHasExpired()
        {
            // arrange
            const int expectedNumberOfClearCacheMethodCalls = 4;
            const long fromEventId = 1;
            const int pageSize = 100;

            ConfigurationManager.AppSettings["DasEngagements.BaseUrl"] = "https://pp-gateway.apprenticeships.education.gov.uk/";
			//ConfigurationManager.AppSettings["DasEngagements.ResourceId"] = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
			//ConfigurationManager.AppSettings["DasEngagements.ClientId"] = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
			//ConfigurationManager.AppSettings["DasEngagements.SecretKey"] = "";
			ConfigurationManager.AppSettings["DasEngagements.SubscriptionKey"] = "";

			var oAuthAccessTokenFactoryMock = new Mock<IOAuthAccessTokenFactory>();
            oAuthAccessTokenFactoryMock.Setup(oatf => oatf.GetAccessToken(
                    It.IsAny<string>(),
                    It.IsAny<string>(),
                    It.IsAny<string>()))
                .Returns("EXPIRED-TOKEN");

            try
            {
                // act
                new DasEventsApiAdapter(oAuthAccessTokenFactoryMock.Object).GetEngagementEventsAfterId(fromEventId, pageSize);
            }
            catch
            {
                // assert 
                oAuthAccessTokenFactoryMock.Verify(oatf => oatf.ClearCache(), Times.Exactly(expectedNumberOfClearCacheMethodCalls),
                    $"ClearCache method was not called {expectedNumberOfClearCacheMethodCalls} times");
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DasEventsApiAdapter_ShouldReturnEventsBeginningWithTheGivenFromEventId()
        {
            // arrange 
            const long fromEventId = 50;
            const int pageSize = 10;

            ConfigurationManager.AppSettings["DasEngagements.BaseUrl"] = "https://pp-gateway.apprenticeships.education.gov.uk/";
			ConfigurationManager.AppSettings["DasEngagements.SubscriptionKey"] = "";

			//ConfigurationManager.AppSettings["DasEngagements.ResourceId"] = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
			//ConfigurationManager.AppSettings["DasEngagements.ClientId"] = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
			//ConfigurationManager.AppSettings["DasEngagements.SecretKey"] = "";

			// act
			IReadOnlyCollection<EngagementEvent> returnedEvents = new DasEventsApiAdapter(new OAuthAccessTokenFactory()).GetEngagementEventsAfterId(fromEventId, pageSize);

            // assert
            Assert.AreEqual(fromEventId, returnedEvents.First().EventId);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DasEventsApiAdapter_ShouldConnectToDasEngagementsProdApi()
        {
            // arrange 
            const long fromEventId = 1;
            const int pageSize = 100;

            ConfigurationManager.AppSettings["DasEngagements.BaseUrl"] = "https://gateway.apprenticeships.education.gov.uk/";
			ConfigurationManager.AppSettings["DasEngagements.SubscriptionKey"] = "";

			//ConfigurationManager.AppSettings["DasEngagements.ResourceId"] = "https://fcsazuresfabisgov.onmicrosoft.com/das-roatpservice-api";
			//ConfigurationManager.AppSettings["DasEngagements.ClientId"] = "29e64f63-0774-4fe5-9941-ae146ed1eb29";
			//ConfigurationManager.AppSettings["DasEngagements.SecretKey"] = "";

			// act
			IReadOnlyCollection<EngagementEvent> returnedEvents = new DasEventsApiAdapter(new OAuthAccessTokenFactory()).GetEngagementEventsAfterId(fromEventId, pageSize);

            // assert
            Assert.IsTrue(returnedEvents.Any(), "GetEngagementEventsAfterId returned no events when calling DasEngagements Prod API");
        }
    }
}
