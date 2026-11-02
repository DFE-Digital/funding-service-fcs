namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.Endpoint.Ioc;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractClosedHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractClosedHandler_ShouldResolve()
        {
            // Arrange
            IWindsorContainer container = new WindsorContainer().Install(new ComponentInstaller(new LoggerFactory()));
            container.Register(Component.For<ContractClosedHandler>());
            container.BeginScope();

            // Act
            var handler = container.Resolve<ContractClosedHandler>();

            // Assert
            Assert.IsNotNull(handler);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractClosedHandler_Handle()
        {
            // Arrange
            List<string> allocationNumbers = new List<string> { "alloc1", "alloc2" };

            var inactiveAllocationsRepoMock = new Mock<IInactiveAllocationRepository>();
            ContractClosedHandler handler = new ContractClosedHandler(inactiveAllocationsRepoMock.Object, Mock.Of<ILogger>());
            var contractClosedEvent = new ContractClosedEvent
            {
                AllocationNumbers = allocationNumbers
            };
            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(contractClosedEvent, context).Wait();

            // Assert
            allocationNumbers.ForEach(an =>
            {
                inactiveAllocationsRepoMock.Verify(m =>
                        m.AddOrUpdate(It.Is<InactiveAllocation>(i =>
                                i.ContractAllocationNumber == an && i.Reason == InactiveReason.Closed),
                            It.IsAny<ConnectionInfo>()), Times.Once,
                    $"AddOrUpdate not called for allocation number {an}");
            });

            inactiveAllocationsRepoMock.Verify(m => m.SaveChanges(), Times.Once);
        }
    }
}
