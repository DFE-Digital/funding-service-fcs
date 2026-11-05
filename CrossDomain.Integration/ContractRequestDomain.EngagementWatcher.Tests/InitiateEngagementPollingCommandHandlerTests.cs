namespace ContractRequestDomain.EngagementWatcher.Tests
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using EngagementWatcher.Services;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.Framework.Logging.Interfaces;
    using IoC;
    using SFA.FCT.Framework.Logging;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using EngagementWatcher.Handlers;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class InitiateEngagementPollingCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void InitiateEngagementPollingCommandHandler_ShouldSendCommandToItselfIfDasApiReturnsAFullPage()
        {
            // arrange
            Mock<ILogger> loggerMock = new Mock<ILogger>();
            Mock<IDasRequestService> dasRequestServiceMock = new Mock<IDasRequestService>();
            
            dasRequestServiceMock.Setup(s => s.GetLatestDasRequests(It.IsAny<int>(), It.IsAny<ConnectionInfo>())).ReturnsAsync(GetDasRequests());
            InitiateEngagementPollingCommandHandler handler = new InitiateEngagementPollingCommandHandler(
                loggerMock.Object,
                dasRequestServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>());
            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(new InitiateEngagementPollingCommand(), context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Count(m => m.Message.GetType() == typeof(InitiateEngagementPollingCommand)));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateEngagementPollingCommandHandler_ShouldResolveWhenUseStubSettingIsTrue()
        {
            // arrange
            ConfigurationManager.AppSettings["DasEngagements.UseStub"] = "true";

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IAzureTableStore>().Instance(Mock.Of<IAzureTableStore>()).Named("AzureTableStoreMock").IsDefault())
                .Register(Component.For<InitiateEngagementPollingCommandHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<InitiateEngagementPollingCommandHandler>();

            // assert
            Assert.IsNotNull(handler);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void InitiateEngagementPollingCommandHandler_ShouldResolveWhenUseStubSettingIsFalse()
        {
            // arrange
            ConfigurationManager.AppSettings["DasEngagements.UseStub"] = "false";

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<InitiateEngagementPollingCommandHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<InitiateEngagementPollingCommandHandler>();

            // assert
            Assert.IsNotNull(handler);
        }

        private DasRequestsResult GetDasRequests()
        {
            List<DasRequest> dasRequests = new List<DasRequest>();
            for (int i = 0; i < 100; i++)
            {
                dasRequests.Add(new DasRequest());
            }
            return new DasRequestsResult(dasRequests.Count, dasRequests);
        }
    }
}
