namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Entities.PaymentInstruction;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationPaymentInstructionReceivedEventHandlerTests
    {
        private Mock<IBus> _busMock;
        private Mock<IPaymentScheduleService> _paymentScheduleServiceMock;
        private AllocationPaymentInstructionReceivedEventHandler _handler;

        [TestInitialize]
        public void TestInitialize()
        {
            _busMock = new Mock<IBus>();
            _paymentScheduleServiceMock = new Mock<IPaymentScheduleService>();
            _handler = new AllocationPaymentInstructionReceivedEventHandler(_busMock.Object, Mock.Of<ILogger>(), _paymentScheduleServiceMock.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentInstructionReceivedEventHandler_Handle_ShouldPersistPaymentSchedule()
        {
            // act
            _handler.Handle(new TestAllocationPaymentInstructionReceivedEvent
            {
                AllocationPaymentInstruction = new AllocationPaymentInstruction()
            });

            // assert
            _paymentScheduleServiceMock.Verify(m => m.SavePaymentSchedule(
                It.IsAny<PaymentSchedule.Allocation>(),
                It.IsAny<IReadOnlyCollection<DeliverablePayment>>(),
                It.Is<ProcessingMode>(pm => pm == ProcessingMode.PaymentInstructionReceived),
                It.IsAny<DateTime?>(),
                It.IsAny<DateTime?>()), Times.Once, "PaymentSchedule was not persisted.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentInstructionReceivedEventHandler_Handle_ShouldPublishPaymentScheduleEvent()
        {
            // act
            _handler.Handle(new TestAllocationPaymentInstructionReceivedEvent
            {
                AllocationPaymentInstruction = new AllocationPaymentInstruction()
            });

            // assert
            _busMock.Verify(m => m.Publish(It.IsAny<Action<PaymentScheduleEvent>>()), Times.Once, "PaymentScheduleEvent was not published.");
        }

        private class TestAllocationPaymentInstructionReceivedEvent : IAllocationPaymentInstructionReceivedEvent 
        {
            public AllocationPaymentInstruction AllocationPaymentInstruction { get; set; }
        }
    }
}
