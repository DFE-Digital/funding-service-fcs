namespace ContractRequestDomain.Tests.BulkUpload.FundingAllocationRelease
{
    using System.Threading.Tasks;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Handlers;
    using SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class FundingAllocationReleaseInProgressHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseInProgressHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<FundingAllocationReleaseInProgressHandler>());
            container.BeginScope();

            // act
            container.Resolve<FundingAllocationReleaseInProgressHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationReleaseInProgressHandler_ShouldMarkReleaseGroupAsInProgress()
        {
            var logger = Mock.Of<ILogger>();
            var repository = new Mock<IFundingAllocationReleaseRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            var context = new TestableMessageHandlerContext();
            var connectionInfo = ConnectionInfo.CreateDefault();
            var message = new FundingAllocationReleaseInProgressEvent("DAS", "2025-26", 42);

            connectionFactory.Setup(x => x.GetConnection(context)).Returns(connectionInfo);
            repository.Setup(x => x.SetToReleaseInProgress(42, "DAS", "2025-26", connectionInfo))
                .Returns(Task.CompletedTask);

            var handler = new FundingAllocationReleaseInProgressHandler(
                logger,
                repository.Object,
                connectionFactory.Object);

            handler.Handle(message, context).Wait();

            repository.Verify(x => x.SetToReleaseInProgress(42, "DAS", "2025-26", connectionInfo), Times.Once);
        }
    }
}
