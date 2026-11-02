namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentSchedule.PaymentAggregated;
    using PaymentSchedule.PaymentAggregated.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;

    [TestClass]
    public class PaymentAggregatedHandlerTests
    {
        private TestableMessageHandlerContext _messageHandlerContext;
        private Mock<IContractDeliverablePeriodPresenceChecker> _contractDeliverablePeriodPresenceCheckerMock;
        private Mock<IPaymentAggregationXrmManager> _paymentAggregationXrmManagerMock;
        private PaymentAggregatedHandler _handler;

        [TestInitialize]
        public void TestInitialize()
        {
            _messageHandlerContext = new TestableMessageHandlerContext();
            _contractDeliverablePeriodPresenceCheckerMock = new Mock<IContractDeliverablePeriodPresenceChecker>();
            _paymentAggregationXrmManagerMock = new Mock<IPaymentAggregationXrmManager>();

            Mock<IProcessedMessageRepository> processedMessageRepository = new Mock<IProcessedMessageRepository>();
            processedMessageRepository.Setup(r =>
                    r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(true);

            _handler = new PaymentAggregatedHandler(
                Mock.Of<ILogger>(),
                Mock.Of<IContractDeliverablePeriodRepository>(),
                _contractDeliverablePeriodPresenceCheckerMock.Object,
                _paymentAggregationXrmManagerMock.Object,
                processedMessageRepository.Object,
                Mock.Of<Infrastructure.ISessionConnectionFactory>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            PaymentAggregatedEventHandler_ShouldNotDeferMessageWhenRequiredContractDeliverablePeriodsArePresent()
        {
            // arrange
            _contractDeliverablePeriodPresenceCheckerMock
                .Setup(m => m.AreAllRequiredContractDeliverablePeriodsPresent(It.IsAny<Allocation>(),
                    It.IsAny<IEnumerable<ContractDeliverablePeriodInfo>>()))
                .Returns(true);

            // act
            _handler.Handle(new AllocationPaymentsChangedOnAggregationEvent
            {
                Allocation = new Allocation
                {
                    AllocationPeriods = new List<AllocationPeriod> {new AllocationPeriod()}
                }
            }, _messageHandlerContext).Wait();

            // assert
            Assert.IsFalse(_messageHandlerContext.SentMessages.Any(), "Unexpected deferred message sent.");
            _paymentAggregationXrmManagerMock.Verify(
                m => m.SavePaymentAggregation(It.IsAny<Allocation>(),
                    It.IsAny<IReadOnlyCollection<ContractDeliverablePeriodInfo>>()),
                Times.Once,
                "Expected call to IPaymentAggregationXrmManager.SavePaymentAggregation not made.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            PaymentAggregatedEventHandler_ShouldDeferMessageWhenRequiredContractDeliverablePeriodsAreNotPresentAndTimesMessageDeferredLessThanThreshold()
        {
            // arrange
            _contractDeliverablePeriodPresenceCheckerMock
                .Setup(m => m.AreAllRequiredContractDeliverablePeriodsPresent(It.IsAny<Allocation>(),
                    It.IsAny<IEnumerable<ContractDeliverablePeriodInfo>>()))
                .Returns(false);

            // act
            _handler.Handle(new AllocationPaymentsChangedOnAggregationEvent
            {
                Allocation = new Allocation
                {
                    AllocationPeriods = new List<AllocationPeriod> {new AllocationPeriod()}
                },
                TimesMessageDeferred = 2
            }, _messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Length,
                "Expected call to send deferred message not made.");
            _paymentAggregationXrmManagerMock.Verify(
                m => m.SavePaymentAggregation(It.IsAny<Allocation>(),
                    It.IsAny<IReadOnlyCollection<ContractDeliverablePeriodInfo>>()),
                Times.Never,
                "Unxpected call to IPaymentAggregationXrmManager.SavePaymentAggregation.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregatedEventHandler_ShouldIncrementTimesMessageDeferredWhenDeferringMessage()
        {
            // arrange
            _contractDeliverablePeriodPresenceCheckerMock
                .Setup(m => m.AreAllRequiredContractDeliverablePeriodsPresent(It.IsAny<Allocation>(),
                    It.IsAny<IEnumerable<ContractDeliverablePeriodInfo>>()))
                .Returns(false);

            // act
            _handler.Handle(new AllocationPaymentsChangedOnAggregationEvent
            {
                Allocation = new Allocation
                {
                    AllocationPeriods = new List<AllocationPeriod> {new AllocationPeriod()}
                },
                TimesMessageDeferred = 2
            }, _messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Length,
                "Expected call to send deferred message not made.");

            var deferredMessage =
                (AllocationPaymentsChangedOnAggregationEvent) _messageHandlerContext.SentMessages.Single().Message;

            Assert.AreEqual(3, deferredMessage.TimesMessageDeferred,
                "TimesMessageDeferred property was not incremented on deferral.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            PaymentAggregatedEventHandler_ShouldThrowArgumentOutOfRangeExceptionWhenRequiredContractDeliverablePeriodsAreNotPresentAndTimesMessageDeferredEqualsThreshold()
        {
            // arrange
            _contractDeliverablePeriodPresenceCheckerMock
                .Setup(m => m.AreAllRequiredContractDeliverablePeriodsPresent(It.IsAny<Allocation>(),
                    It.IsAny<IEnumerable<ContractDeliverablePeriodInfo>>()))
                .Returns(false);

            bool threwExpectedException = false;

            // act
            try
            {
                _handler.Handle(new AllocationPaymentsChangedOnAggregationEvent
                {
                    Allocation = new Allocation
                    {
                        AllocationPeriods = new List<AllocationPeriod> {new AllocationPeriod()}
                    },
                    TimesMessageDeferred = 40
                }, _messageHandlerContext).Wait();
            }
            catch (AggregateException aex) when (aex.InnerExceptions.SingleOrDefault() is ArgumentOutOfRangeException)
            {
                threwExpectedException = true;
            }

            Assert.IsTrue(threwExpectedException);
        }

        [TestMethod, TestCategory("UnitTest")]

        public void PaymentAggregatedEventHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new PaymentManagementDomain.PaymentSchedule.PaymentAggregated.WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<PaymentAggregatedHandler>().ImplementedBy<PaymentAggregatedHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<PaymentAggregatedHandler>();
        }
    }
}
