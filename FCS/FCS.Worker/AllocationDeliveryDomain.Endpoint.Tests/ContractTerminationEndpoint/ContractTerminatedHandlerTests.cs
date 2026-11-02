namespace AllocationDeliveryDomain.Endpoint.Tests.ContractTerminationEndpoint
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractTerminationEndpoint;
    using Endpoint.Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractTerminatedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminatedHandler_ShouldAddOrUpdateInactiveAllocations()
        {
            // arrange
            Mock<IInactiveAllocationRepository> inactiveAllocationRepositoryMock = new Mock<IInactiveAllocationRepository>();

            ContractTerminatedHandler handler = new ContractTerminatedHandler(inactiveAllocationRepositoryMock.Object, Mock.Of<ISessionConnectionFactory>(), (Mock.Of<ILogger>()));

            ContractTerminatedEvent eventToHandle = new ContractTerminatedEvent
            {
                ContractNumber = "ABC-123",
                VersionNumber = 1,
                SubVersionNumber = 0,
                AllocationNumbers = new List<string>
                {
                    "ALLOC1", "ALLOC2", "ALLOC3"
                }
            };

            // act
            handler.Handle(eventToHandle, Mock.Of<IMessageHandlerContext>());

            // assert
            eventToHandle.AllocationNumbers
                .ForEach(allocNum => inactiveAllocationRepositoryMock.Verify(m =>
                    m.AddOrUpdate(
                        It.Is<InactiveAllocation>(ia =>
                            string.Equals(ia.ContractAllocationNumber, allocNum) &&
                            ia.Reason == InactiveReason.Terminated),
                        It.IsAny<ConnectionInfo>()),
                    Times.Once));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractTerminatedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractTerminatedHandler>().ImplementedBy<ContractTerminatedHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<ContractTerminatedHandler>();
        }
    }
}