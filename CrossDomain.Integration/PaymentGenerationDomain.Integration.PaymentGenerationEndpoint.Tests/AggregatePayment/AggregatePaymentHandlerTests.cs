namespace PaymentGenerationDomain.Integration.PaymentGeneration.AggregatePayment
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Common.Exceptions;
    using Moq;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using NServiceBus.Testing;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.DTOs;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.Ioc;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories;
    using PaymentGenerationEndpoint.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.Framework.Logging;

    [TestClass]
    public class AggregatePaymentHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AggregatePaymentHandler_ShouldPublishIAllocationPaymentsChangedOnAggregationEvent()
        {
            const string allocationNumber = "ALLOC-1234";
            const bool hasOutstandingPaymentsForAllocation = true;

            var mapperMock = new Mock<IAggregatedPaymentMapper>();
            mapperMock
                .Setup(m => m.MapAggregatedPaymentCorporateSchemaToDbEntities(It.IsAny<Allocation>()))
                .Returns(new List<DataStore.Model.SubnominalAggregation>());

            var outstandingPaymentsCheckerMock = new Mock<IOutstandingPaymentsChecker>();
            outstandingPaymentsCheckerMock
                .Setup(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(hasOutstandingPaymentsForAllocation);

            var handler = new AggregatePaymentHandler(
                Mock.Of<ILogger>(),
                outstandingPaymentsCheckerMock.Object,
                Mock.Of<IUpSertSubmoninalAggregationService>(),
                Mock.Of<ISubnominalAggregationRepository>(),
                Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            // Act
            handler.Handle(new PaymentAggregatedEvent
            {
                Allocation = new Allocation
                {
                    AllocationNumber = allocationNumber
                }
            }, context).Wait();

            // Assert
            outstandingPaymentsCheckerMock
                .Verify(m => m.HasOutstandingPaymentsForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Once, $"Expected HasOutstandingPaymentsForAllocation call not made to {typeof (IOutstandingPaymentsChecker)}");

            List<AllocationPaymentsChangedOnAggregationEvent> publishedMessages =
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<AllocationPaymentsChangedOnAggregationEvent>()
                    .ToList();

            Assert.AreEqual(1, publishedMessages.Count, "Expected message not published");

            AllocationPaymentsChangedOnAggregationEvent publishedEvent = publishedMessages.Single();

            Assert.IsNotNull(publishedEvent, "The published event  was not set");
            Assert.AreEqual(publishedEvent.AllocationNumber, allocationNumber, "Event published had an unexpected allocation number");
            Assert.AreEqual(publishedEvent.HasOutstandingPayments, hasOutstandingPaymentsForAllocation, "Event published had an unexpected HasOutstandingPayments value");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregatePaymentHandler_ShouldThrowInvalidPeriodTypeCodeException_IfAnyAggregationsNotCalendarMonth()
        {
            var loggerMock = new Mock<ILogger>();

            var testAllocation = new Allocation()
            {
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Period = "201508",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.FP
                    }
                }
            };

            var message = new PaymentAggregatedEvent {Allocation = testAllocation};

            var handler = new AggregatePaymentHandler(
                loggerMock.Object,
                Mock.Of<IOutstandingPaymentsChecker>(),
                Mock.Of<IUpSertSubmoninalAggregationService>(),
                Mock.Of<ISubnominalAggregationRepository>(),
                Mock.Of<ISessionConnectionFactory>());

            try
            {
                handler.Handle(message, new TestableMessageHandlerContext()).Wait();
                Assert.Fail("Handle_IPaymentAggregated event did not throw an exeption for a period type code not calendar month.");
            }
            catch(AggregateException e)
            {
                Assert.IsInstanceOfType(e.InnerException, typeof(InvalidPeriodTypeCodeException));
            }
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregatePaymentHandler_ShouldPublishUnpostedSubnominalsOnly()
        {
            var loggerMock = new Mock<ILogger>();
            var subnominalAggregationRepositoryMock = new Mock<ISubnominalAggregationRepository>();

            subnominalAggregationRepositoryMock
                .Setup(r => r.GetSubnominalAggregations(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(
                    (string allocationNumber, string period, ConnectionInfo ci) => new List<SimpleSubnominalAggregation>
                    {
                        new SimpleSubnominalAggregation("", period, "", "", period == "201908")
                    });

            var testAllocation = new Allocation()
            {
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Period = "201908",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM
                    },
                    new AllocationPeriod
                    {
                        Period = "201909",
                        PeriodTypeCode = AllocationPeriodPeriodTypeCode.CM
                    }
                }
            };

            var message = new PaymentAggregatedEvent {Allocation = testAllocation};

            var handler = new AggregatePaymentHandler(
                loggerMock.Object,
                Mock.Of<IOutstandingPaymentsChecker>(),
                Mock.Of<IUpSertSubmoninalAggregationService>(),
                subnominalAggregationRepositoryMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            var context = new TestableMessageHandlerContext();

            //act
            handler.Handle(message, context).Wait();

            // assert
            List<AllocationPaymentsChangedOnAggregationEvent> paymentAggregationsHaveChangedEvents =
                context.PublishedMessages
                    .Select(m => m.Message)
                    .OfType<AllocationPaymentsChangedOnAggregationEvent>()
                    .ToList();

            Assert.AreEqual(1, paymentAggregationsHaveChangedEvents.Count, "The number of AllocationPaymentsChangedOnAggregationEvent published is incorrect");

            int numPeriodsThatHaveChanged =
                paymentAggregationsHaveChangedEvents.First().Allocation.AllocationPeriods.Count;

            Assert.AreEqual(1, numPeriodsThatHaveChanged, "The number of periods that have changed on AllocationPaymentsChangedOnAggregationEvent is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AggregatePaymentHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            IWindsorContainer container = new WindsorContainer().Install(new AggregatePaymentWindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<AggregatePaymentHandler>());
            container.BeginScope();

            container.Resolve<AggregatePaymentHandler>();
        }

        private class TestAllocationPaymentsChangedOnAggregationEvent : AllocationPaymentsChangedOnAggregationEvent 
        {
            public string AllocationNumber { get; set; }

            public bool HasOutstandingPayments { get; set; }
        }
    }
}
