namespace ContractRequestDomain.EngagementWatcher.Tests.Handlers
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Repositories;
    using EngagementWatcher.Handlers;
    using EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class RetryNotFoundProviderEngagementsCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenEventsAreFound_ShouldSendCommandsAndMarkDuplicates()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var request = new DasRequest { DasEngagementEventId = 123, Ukprn = 45678901 };
            var requests = new DasRequestsResult(
                2,
                new[] { request },
                new long[] { 987 });
            var requestService = new Mock<IDasRequestService>();
            requestService.Setup(x => x.GetProviderNotFoundEvents(connectionInfo)).ReturnsAsync(requests);
            var engagementRepository = new Mock<IEngagementEventRepository>();
            engagementRepository.Setup(x => x.MarkEventsAsDuplicate(requests.DuplicateEvents, connectionInfo))
                .Returns(Task.CompletedTask);
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            var handler = new RetryNotFoundProviderEngagementsCommandHandler(
                Mock.Of<ILogger>(),
                requestService.Object,
                engagementRepository.Object,
                connectionFactory.Object);

            handler.Handle(new RetryNotFoundProviderEngagementsCommand(), context).Wait();

            Assert.AreEqual(1, context.SentMessages.Length);
            var sentCommand = (NewDasContractRequestCommand)context.SentMessages[0].Message;
            Assert.AreSame(request, sentCommand.DasRequest);
            Assert.AreEqual(123, sentCommand.DasEngagementEventId);
            engagementRepository.Verify(x => x.MarkEventsAsDuplicate(requests.DuplicateEvents, connectionInfo), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenNoEventsAreFound_ShouldMarkEmptyDuplicateCollection()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var requests = new DasRequestsResult(0, new List<DasRequest>());
            var requestService = new Mock<IDasRequestService>();
            requestService.Setup(x => x.GetProviderNotFoundEvents(connectionInfo)).ReturnsAsync(requests);
            var engagementRepository = new Mock<IEngagementEventRepository>();
            engagementRepository.Setup(x => x.MarkEventsAsDuplicate(requests.DuplicateEvents, connectionInfo))
                .Returns(Task.CompletedTask);
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            var handler = new RetryNotFoundProviderEngagementsCommandHandler(
                Mock.Of<ILogger>(),
                requestService.Object,
                engagementRepository.Object,
                connectionFactory.Object);

            handler.Handle(new RetryNotFoundProviderEngagementsCommand(), context).Wait();

            Assert.AreEqual(0, context.SentMessages.Length);
            engagementRepository.Verify(x => x.MarkEventsAsDuplicate(requests.DuplicateEvents, connectionInfo), Times.Once);
        }
    }
}
