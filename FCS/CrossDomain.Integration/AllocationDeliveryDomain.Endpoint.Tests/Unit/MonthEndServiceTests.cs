namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class MonthEndServiceTests
    {
        private MonthEndService _monthEndService;
        private Mock<IMonthEndHistoryRepository> _monthEndHistoryRepositoryMock;
        private Mock<IAzureServiceBusQueryService> _azureServiceBusQueryServiceMock;

        [TestInitialize]
        public void TestInitialize()
        {
            _monthEndHistoryRepositoryMock = new Mock<IMonthEndHistoryRepository>();
            _azureServiceBusQueryServiceMock = new Mock<IAzureServiceBusQueryService>();
            _monthEndService = new MonthEndService(_monthEndHistoryRepositoryMock.Object, _azureServiceBusQueryServiceMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_MarkMonthEndAsStarted_ShouldInvokeMonthEndHistoryRepositoryStartMonthEndMethod()
        {
            // act
            _monthEndService.MarkMonthEndAsStarted(ConnectionInfo.CreateDefault());

            // assert
            _monthEndHistoryRepositoryMock.Verify(m => m.StartMonthEnd(It.IsAny<ConnectionInfo>()), Times.Once, "MonthEndHistoryRepository StartMonthEnd method was not invoked.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_MarkMonthEndAsCompleted_ShouldInvokeMonthEndHistoryRepositoryStopMonthEndMethod()
        {
            // act
            _monthEndService.MarkMonthEndAsCompleted(ConnectionInfo.CreateDefault());

            // assert
            _monthEndHistoryRepositoryMock.Verify(m => m.StopMonthEnd(It.IsAny<ConnectionInfo>()), Times.Once, "MonthEndHistoryRepository StopMonthEnd method was not invoked.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndInitialDeferralPeriodExpired_ShouldReturnTrueWhenMonthEndInitialDeferralPeriodHasExpired()
        {
            // arrange
            _monthEndHistoryRepositoryMock
                .Setup(m => m.GetCurrentMonthEndStartTime(It.IsAny<ConnectionInfo>()))
                .Returns(DateTime.UtcNow.Subtract(TimeSpan.FromMinutes(12)));

            // act
            bool hasMonthEndInitialDeferralPeriodExpired = _monthEndService.HasMonthEndInitialDeferralPeriodExpired(ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(hasMonthEndInitialDeferralPeriodExpired, "HasMonthEndInitialDeferralPeriodExpired did not return true.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndInitialDeferralPeriodExpired_ShouldReturnTrueWhenMonthEndHistoryRepositoryCannotFindAnyMonthEndHistory()
        {
            // arrange
            _monthEndHistoryRepositoryMock
                .Setup(m => m.GetCurrentMonthEndStartTime(It.IsAny<ConnectionInfo>()))
                .Returns<DateTime?>(null);

            // act
            bool hasMonthEndInitialDeferralPeriodExpired = _monthEndService.HasMonthEndInitialDeferralPeriodExpired(ConnectionInfo.CreateDefault());

            // assert
            Assert.IsTrue(hasMonthEndInitialDeferralPeriodExpired, "HasMonthEndInitialDeferralPeriodExpired did not return true.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndInitialDeferralPeriodExpired_ShouldReturnFalseWhenMonthEndInitialDeferralPeriodHasNotExpired()
        {
            // arrange
            _monthEndHistoryRepositoryMock
                .Setup(m => m.GetCurrentMonthEndStartTime(It.IsAny<ConnectionInfo>()))
                .Returns(DateTime.UtcNow.Subtract(TimeSpan.FromMinutes(3)));

            // act
            bool hasMonthEndInitialDeferralPeriodExpired = _monthEndService.HasMonthEndInitialDeferralPeriodExpired(ConnectionInfo.CreateDefault());

            // assert
            Assert.IsFalse(hasMonthEndInitialDeferralPeriodExpired, "HasMonthEndInitialDeferralPeriodExpired did not return false.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndServiceBusActivityCompleted_ShouldReturnTrueWhenAllMonthEndQueuesAndTopicsEmpty()
        {
            // arrange
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetQueueMessageCount(It.IsAny<string>()))
                .Returns(0);
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetTopicMessageCount(It.IsAny<string>()))
                .Returns(0);

            // act
            bool hasMonthEndServiceBusActivityCompleted = _monthEndService.HasMonthEndServiceBusActivityCompleted();

            // assert
            Assert.IsTrue(hasMonthEndServiceBusActivityCompleted, "HasMonthEndServiceBusActivityCompleted did not return true.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndServiceBusActivityCompleted_ShouldReturnFalseWhenNotAllMonthEndQueuesEmpty()
        {
            // arrange
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetQueueMessageCount(It.Is<string>(s => s == "allocationdeliverydomain.validation")))
                .Returns(500);
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetTopicMessageCount(It.IsAny<string>()))
                .Returns(0);

            // act
            bool hasMonthEndServiceBusActivityCompleted = _monthEndService.HasMonthEndServiceBusActivityCompleted();

            // assert
            Assert.IsFalse(hasMonthEndServiceBusActivityCompleted, "HasMonthEndServiceBusActivityCompleted did not return false.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndServiceBusActivityCompleted_ShouldReturnTrueWhenObsoleteQueueHasMessages()
        {
            // arrange
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetQueueMessageCount(It.Is<string>(s => s == "allocationdeliverydomain.endpoint")))
                .Returns(500);
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetTopicMessageCount(It.IsAny<string>()))
                .Returns(0);

            // act
            bool hasMonthEndServiceBusActivityCompleted = _monthEndService.HasMonthEndServiceBusActivityCompleted();

            // assert
            Assert.IsTrue(hasMonthEndServiceBusActivityCompleted, "HasMonthEndServiceBusActivityCompleted did not return true.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_HasMonthEndServiceBusActivityCompleted_ShouldReturnFalseWhenNotAllMonthEndTopicsEmpty()
        {
            // arrange
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetQueueMessageCount(It.IsAny<string>()))
                .Returns(0);
            _azureServiceBusQueryServiceMock
                .Setup(m => m.GetTopicMessageCount(It.Is<string>(s => s == "paymentmanagementdomain.paymentaggregation.events")))
                .Returns(500);

            // act
            bool hasMonthEndServiceBusActivityCompleted = _monthEndService.HasMonthEndServiceBusActivityCompleted();

            // assert
            Assert.IsFalse(hasMonthEndServiceBusActivityCompleted, "HasMonthEndServiceBusActivityCompleted did not return false.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MonthEndService_ShouldResolveFromDedsPollerEndpointContainer()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new IoC.WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                container.Resolve<IMonthEndService>();
            }
        }
    }
}
