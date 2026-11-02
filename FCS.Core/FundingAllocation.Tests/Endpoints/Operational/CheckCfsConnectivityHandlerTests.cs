namespace FundingAllocation.Tests.Endpoints.Operational
{
    using System;
    using System.Linq;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.Operational;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CheckCfsConnectivityHandlerTests
    {
        private const string CfsApiServiceName = "CFS_API";
        private const string CfsProviderApiServiceName = "CFS_PROVIDER_API";
        [TestMethod, TestCategory("UnitTest")]
        public void CheckCfsConnectivityHandler_ShouldResolve()
        {
            // arrange
            var container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<CheckCfsConnectivityHandler>());

            // act
            container.Resolve<CheckCfsConnectivityHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckCfsConnectivityHandler_ShouldSendMessageWithTwoPostiveResults_WhenApiIsWorking()
        {
            // arrange
            Mock<IFundingNotificationApi> fundingNotificationApiMock = new Mock<IFundingNotificationApi>();
            fundingNotificationApiMock.Setup(r => r.GetLatestPageData())
                .ReturnsAsync(new CfsLatestPageData(new AtomItem[1] {new AtomItem
                {
                    ProviderFundingIds = new[]{""}
                }}, 1));
            fundingNotificationApiMock.Setup(r => r.GetProviderFundingAllocation(It.IsAny<string>()))
                .ReturnsAsync(new ProviderFundingAllocationApiDto());

            CheckCfsConnectivityHandler handler = new CheckCfsConnectivityHandler(Mock.Of<ILogger>(), fundingNotificationApiMock.Object, Mock.Of<IConfigurationRoot>());
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();
            
            // act
            handler.Handle(new CheckConnectivityCommand(), context).Wait();

            // assert
            context.RepliedMessages.Length.Should().Be(1);
            context.RepliedMessages.Single().Message.Should().BeOfType(typeof(CheckConnectivityReply));
            var sentMessage = (CheckConnectivityReply) context.RepliedMessages.Single().Message;
            sentMessage.Results.Count.Should().Be(2);
            sentMessage.Results.All(r => r.CanConnect).Should().BeTrue();
            sentMessage.Results.Any(r => r.Service == CfsApiServiceName).Should().BeTrue();
            sentMessage.Results.Any(r => r.Service == CfsProviderApiServiceName).Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckCfsConnectivityHandler_ShouldSendMessageWithZeroPostiveResults_WhenApiIsNotWorking()
        {
            // arrange
            Mock<IFundingNotificationApi> fundingNotificationApiMock = new Mock<IFundingNotificationApi>();
            fundingNotificationApiMock.Setup(r => r.GetLatestPageData())
                .ThrowsAsync(new Exception());
            fundingNotificationApiMock.Setup(r => r.GetProviderFundingAllocation(It.IsAny<string>()))
                .ThrowsAsync(new Exception());

            CheckCfsConnectivityHandler handler = new CheckCfsConnectivityHandler(Mock.Of<ILogger>(), fundingNotificationApiMock.Object, Mock.Of<IConfigurationRoot>());
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new CheckConnectivityCommand(), context).Wait();

            // assert
            context.RepliedMessages.Length.Should().Be(1);
            context.RepliedMessages.Single().Message.Should().BeOfType(typeof(CheckConnectivityReply));
            var sentMessage = (CheckConnectivityReply)context.RepliedMessages.Single().Message;
            sentMessage.Results.Count.Should().Be(2);
            sentMessage.Results.All(r => !r.CanConnect).Should().BeTrue();
            sentMessage.Results.Any(r => r.Service == CfsApiServiceName).Should().BeTrue();
            sentMessage.Results.Any(r => r.Service == CfsProviderApiServiceName).Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckCfsConnectivityHandler_ShouldSendMessageWithPostiveCfsAndFailedProviderApi_WhenProviderApiIsNotWorking()
        {
            // arrange
            Mock<IFundingNotificationApi> fundingNotificationApiMock = new Mock<IFundingNotificationApi>();
            fundingNotificationApiMock.Setup(r => r.GetLatestPageData())
                .ReturnsAsync(new CfsLatestPageData(new AtomItem[1] {new AtomItem
                {
                    ProviderFundingIds = new[]{""}
                }}, 1));
            fundingNotificationApiMock.Setup(r => r.GetProviderFundingAllocation(It.IsAny<string>()))
                .ThrowsAsync(new Exception());

            CheckCfsConnectivityHandler handler = new CheckCfsConnectivityHandler(Mock.Of<ILogger>(), fundingNotificationApiMock.Object, Mock.Of<IConfigurationRoot>());
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new CheckConnectivityCommand(), context).Wait();

            // assert
            context.RepliedMessages.Length.Should().Be(1);
            context.RepliedMessages.Single().Message.Should().BeOfType(typeof(CheckConnectivityReply));
            var sentMessage = (CheckConnectivityReply)context.RepliedMessages.Single().Message;
            sentMessage.Results.Count.Should().Be(2);
            sentMessage.Results.Any(r => !r.CanConnect && r.Service == CfsProviderApiServiceName).Should().BeTrue();
            sentMessage.Results.Any(r => r.CanConnect && r.Service == CfsApiServiceName).Should().BeTrue();
        }
    }
}
