namespace ContractRequestDomain.EngagementWatcher.Tests.Handlers
{
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using SFA.FCT.ContractRequestDomain.EngagementWatcher.Handlers;
    using SFA.FCT.ContractRequestDomain.EngagementWatcher.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DasContractRequestEventHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreatedEventHandler_ShouldMarkEngagementAsInCrm()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var repository = new Mock<IEngagementEventRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            repository.Setup(x => x.Update(123, "CON-456", EngagementEventProcessingState.InCrm, connectionInfo))
                .Returns(Task.CompletedTask);

            var handler = new DasContractRequestCreatedEventHandler(
                Mock.Of<ILogger>(),
                repository.Object,
                connectionFactory.Object);

            handler.Handle(new DasContractRequestCreatedEvent
            {
                DasEngagementEventId = 123,
                ContractNumber = "CON-456"
            }, context).Wait();

            repository.Verify(x => x.Update(123, "CON-456", EngagementEventProcessingState.InCrm, connectionInfo), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RejectedEventHandler_ShouldMarkEngagementAsRejectedByRule()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var repository = new Mock<IEngagementEventRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            repository.Setup(x => x.Update(123, null, EngagementEventProcessingState.RejectedByRule, connectionInfo))
                .Returns(Task.CompletedTask);

            var handler = new DasContractRequestRejectedEventHandler(
                Mock.Of<ILogger>(),
                repository.Object,
                connectionFactory.Object);

            handler.Handle(new DasContractRequestRejectedEvent { DasEngagementEventId = 123 }, context).Wait();

            repository.Verify(x => x.Update(123, null, EngagementEventProcessingState.RejectedByRule, connectionInfo), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderNotFoundEventHandler_ShouldMarkEngagementProviderAsNotFound()
        {
            var connectionInfo = ConnectionInfo.CreateDefault();
            var context = new TestableMessageHandlerContext();
            var repository = new Mock<IEngagementEventRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            repository.Setup(x => x.Update(123, null, EngagementEventProcessingState.ProviderNotFound, connectionInfo))
                .Returns(Task.CompletedTask);

            var handler = new DasContractRequestProviderNotFoundEventHandler(
                Mock.Of<ILogger>(),
                repository.Object,
                connectionFactory.Object);

            handler.Handle(new DasContractRequestProviderNotFoundEvent { DasEngagementEventId = 123 }, context).Wait();

            repository.Verify(x => x.Update(123, null, EngagementEventProcessingState.ProviderNotFound, connectionInfo), Times.Once);
        }
    }
}
