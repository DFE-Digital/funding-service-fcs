namespace Operations.Web.Tests.ServiceTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.Web.Repositories;
    using System.Threading.Tasks;
    using System;
    using Moq;
    using Services;

    [TestClass]
    public class DasRequestServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DasRequestService_SetupDasRequest_ShouldAddEngagementEventAndReturnDasRequest()
        {
            // arrange 
            const string ukprn = "123456781";
            const int eventId = 666;
            const string levyFundingType = "LEVY";
            var startDate = new DateTime(2017, 5, 1);

            var mockFundingTypeFundingPeriodRepository = new Mock<IFundingTypeFundingPeriodRepository>();
            mockFundingTypeFundingPeriodRepository.Setup(m => m.GetLevyDefaultContractStartDate())
                .Returns(Task.FromResult(startDate));

            var dasRequestService = new DasRequestService(mockFundingTypeFundingPeriodRepository.Object);

            // act
            var dasRequest = dasRequestService.SetupDasRequest(ukprn, eventId).Result;
            
            // arrange
            Assert.AreEqual(ukprn, dasRequest.Ukprn.ToString(), "ukprn is incorrect");
            Assert.AreEqual(eventId, dasRequest.DasEngagementEventId, "eventId is incorrect");
            Assert.AreEqual(startDate, dasRequest.StartDate, "startDate is incorrect");
            Assert.AreEqual(levyFundingType, dasRequest.FundingType, "levyFundingType is incorrect");
        }
    }
}