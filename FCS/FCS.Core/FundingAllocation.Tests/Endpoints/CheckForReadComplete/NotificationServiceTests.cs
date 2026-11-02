namespace FundingAllocation.Tests.Endpoints.CheckForReadComplete
{
    using FundingAllocation.Endpoints.CheckForReadComplete;
    using FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using FundingAllocation.Slack;

    [TestClass]
    public class NotificationServiceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void NotificationService_ShouldSendWhenParkedFundingAllocationsPresent()
        {
            Mock<ICheckForReadCompleteFundingAllocationRepository> fundingAllocationRepositoryMock = new Mock<ICheckForReadCompleteFundingAllocationRepository>();
            fundingAllocationRepositoryMock.Setup(r => r.GetNumParkedNotAwaitingOutcome(1)).ReturnsAsync(1);
            var appConfigurationRoot = AppConfiguration.Configuration();

            CreateProvidersIfNecessaryNotificationService service = new CreateProvidersIfNecessaryNotificationService(
                new SlackMessageSender(appConfigurationRoot),
                Mock.Of<ILogger>(),
                appConfigurationRoot);
            service.NotifySlackRegardingProviderNotFoundChangedToConfigFailure("1").Wait();
        }
    }
}
