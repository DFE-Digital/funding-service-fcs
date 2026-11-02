namespace SFA.FCT.ContractManagementDomain.Integration.Tests.IntegrationEndpoint
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using ContractManagementDomain.Integration.IntegrationEndpoint;
    using ContractManagementDomain.Integration.IntegrationEndpoint.IoC;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Events;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;

    [TestClass]
    public class AllocationPaymentsChangedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentsChangedHandler_ShouldInvokeRepositoryStorageWithMessageValues()
        {
            const string allocationNumber = "ALLOC-1234";
            const bool hasOutstandingPayments = true;

            // arrange
            var approvedContractAllocationRepositoryMock = new Mock<IApprovedContractAllocationRepository>();

            var handler = new AllocationPaymentsChangedHandler(
                Mock.Of<ILogger>(),
                approvedContractAllocationRepositoryMock.Object, Mock.Of<ISessionConnectionFactory>());

            var messageMock = new Mock<IAllocationPaymentsChangedOnPostingEvent>();
            messageMock.SetupGet(m => m.AllocationNumber).Returns(allocationNumber);
            messageMock.SetupGet(m => m.HasOutstandingPayments).Returns(hasOutstandingPayments);

            // act
            handler.Handle(messageMock.Object, new TestableMessageHandlerContext()).Wait();

            // arrange
            approvedContractAllocationRepositoryMock.Verify(
                m => m.SetOutstandingPaymentsIndicator(allocationNumber, hasOutstandingPayments, It.IsAny<ConnectionInfo>()),
                Times.Once,
                "ApprovedContractAllocationRepository was not invoked with expected values");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentsChangedHandler_ShouldResolveDependenciesFromIntegrationEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<AllocationPaymentsChangedHandler>());
            container.BeginScope();

            // act
            var handler = container.Resolve<AllocationPaymentsChangedHandler>();

            // assert
            Assert.IsNotNull(handler);
        }

    }
}
