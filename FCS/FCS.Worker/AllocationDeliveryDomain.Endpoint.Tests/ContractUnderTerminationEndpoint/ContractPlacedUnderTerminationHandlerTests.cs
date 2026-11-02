namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDeliveryDomain.Endpoint.ContractUnderTerminationEndpoint;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ContractUnderTerminationEndpoint.Services;
    using Endpoint.Infrastructure;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractTermination;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractPlacedUnderTerminationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractPlacedUnderTerminationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractPlacedUnderTerminationHandler>().ImplementedBy<ContractPlacedUnderTerminationHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<ContractPlacedUnderTerminationHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractPlacedUnderTerminationHandler_ContractPlacedUnderTerminationForApproveInitiation_WhenActualsAreZeroisedShouldPublishAllocationActualsUpdatedEvents()
        {
            // arrange
            Mock<IZeroiseActualsService> zeroiseActualsServiceMock = new Mock<IZeroiseActualsService>();
            zeroiseActualsServiceMock
                .Setup(m => m.ConditionallyZeroiseActuals(It.IsAny<ConnectionInfo>(), It.IsAny<TerminationAllocation>(), It.IsAny<Func<ContractAllocationActualsType, Task>>()))
                .Callback<ConnectionInfo, TerminationAllocation, Func<ContractAllocationActualsType, Task>>((c, a, publish) => publish(new ContractAllocationActualsType()))
                .Returns(Task.FromResult(0));

            ContractPlacedUnderTerminationHandler handler = new ContractPlacedUnderTerminationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IAllocationUnderTerminationRepository>(),
                Mock.Of<ISessionConnectionFactory>(),
                zeroiseActualsServiceMock.Object);

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new ContractPlacedUnderTerminationForApproveInitiationEvent
            {
                TerminationAllocations = new List<TerminationAllocation>
                {
                    new TerminationAllocation("ALLOC-1", "FSP-1", DateTime.UtcNow),
                    new TerminationAllocation("ALLOC-2", "FSP-2", DateTime.UtcNow)
                }
            }, messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(2, messageHandlerContext.PublishedMessages.Length, "Unexpected number of messages published");
            Assert.AreEqual(2, messageHandlerContext.PublishedMessages.Count(m => m.Message is AllocationActualsUpdated), $"Unexpected number of {nameof(AllocationActualsUpdated)} messages published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractPlacedUnderTerminationHandler_ContractPlacedUnderTerminationForUpdatedDetails_WhenActualsAreZeroisedShouldPublishAllocationActualsUpdatedEvents()
        {
            // arrange
            Mock<IZeroiseActualsService> zeroiseActualsServiceMock = new Mock<IZeroiseActualsService>();
            zeroiseActualsServiceMock
                .Setup(m => m.ConditionallyZeroiseActuals(It.IsAny<ConnectionInfo>(), It.IsAny<TerminationAllocation>(), It.IsAny<Func<ContractAllocationActualsType, Task>>()))
                .Callback<ConnectionInfo, TerminationAllocation, Func<ContractAllocationActualsType, Task>>((c, a, publish) => publish(new ContractAllocationActualsType()))
                .Returns(Task.FromResult(0));

            ContractPlacedUnderTerminationHandler handler = new ContractPlacedUnderTerminationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IAllocationUnderTerminationRepository>(),
                Mock.Of<ISessionConnectionFactory>(),
                zeroiseActualsServiceMock.Object);

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new ContractPlacedUnderTerminationForUpdatedDetailsEvent
            {
                TerminationAllocations = new List<TerminationAllocation>
                {
                    new TerminationAllocation("ALLOC-1", "FSP-1", DateTime.UtcNow),
                    new TerminationAllocation("ALLOC-2", "FSP-2", DateTime.UtcNow)
                }
            }, messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(2, messageHandlerContext.PublishedMessages.Length, "Unexpected number of messages published");
            Assert.AreEqual(2, messageHandlerContext.PublishedMessages.Count(m => m.Message is AllocationActualsUpdated), $"Unexpected number of {nameof(AllocationActualsUpdated)} messages published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractPlacedUnderTerminationHandler_WhenActualsAreZeroised_ShouldPublishAllocationActualsUpdatedEventForTheVersionTerminated()
        {
            // arrange
            const int contractVersion = 2;
            Mock<IZeroiseActualsService> zeroiseActualsServiceMock = new Mock<IZeroiseActualsService>();
            zeroiseActualsServiceMock
                .Setup(m => m.ConditionallyZeroiseActuals(It.IsAny<ConnectionInfo>(), It.IsAny<TerminationAllocation>(), It.IsAny<Func<ContractAllocationActualsType, Task>>()))
                .Callback<ConnectionInfo, TerminationAllocation, Func<ContractAllocationActualsType, Task>>((c, a, publish) => publish(new ContractAllocationActualsType()))
                .Returns(Task.FromResult(0));

            ContractPlacedUnderTerminationHandler handler = new ContractPlacedUnderTerminationHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IAllocationUnderTerminationRepository>(),
                Mock.Of<ISessionConnectionFactory>(),
                zeroiseActualsServiceMock.Object);

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new ContractPlacedUnderTerminationForApproveInitiationEvent()
            {
                TerminationAllocations = new List<TerminationAllocation>
                {
                    new TerminationAllocation("ALLOC-1", "FSP-1", DateTime.UtcNow),
                    new TerminationAllocation("ALLOC-2", "FSP-2", DateTime.UtcNow)
                },
                VersionNumber = contractVersion
            }, messageHandlerContext).Wait();

            // assert
            IEnumerable<AllocationActualsUpdated> allocationActualsUpdated = messageHandlerContext.PublishedMessages.Select(pm => pm.Message).Cast<AllocationActualsUpdated>().ToList();
            Assert.IsTrue(allocationActualsUpdated.All(a =>
                    a.AllocationActuals.ContractReference.ContractVersionNumber == contractVersion), "The contract version is not correct");
        }

        private IReadOnlyCollection<AllocationDeliverablePeriodActualAudit> GetActuals()
        {
            return Enumerable.Range(1, 12).SelectMany(i =>
                Enumerable.Range(1, 12).Select(j =>
                    new AllocationDeliverablePeriodActualAudit
                    {
                        ActualVolume = 50,
                        ActualValue = 5000,
                        ContractVersion = 1,
                        Period = $"2018{j:D2}",
                        CollectionReturnPeriod = int.Parse($"2018{i:D2}")
                    })).ToList();
        }
    }
}