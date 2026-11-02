namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Events;
    using Dtos;
    using Framework.Logging.Interfaces;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Services;
    using Utils;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationDeliveryCommencedHandlerControllerTests
    {
        private Mock<IBus> _busMock;
        private Mock<IPayCalcPolicyQueryRepository> _policyRepositoryMock;
        private Mock<IPaymentManager> _paymentManagerMock;
        private Mock<IPaymentScheduleCreator> _paymentScheduleCreatorMock;
        private Mock<IDate> _dateProviderMock;
        private AllocationDeliveryCommencedHandler _allocationDeliveryCommencedHandler;

        [TestInitialize]
        public void TestInitialize()
        {
            Mock<IPaymentScheduleService> paymentScheduleServiceMock = new Mock<IPaymentScheduleService>();

            _policyRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            _policyRepositoryMock
                .Setup(x => x.GetFundingStreamPeriod(It.Is<string>(s => s == "ASC1516")))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnProfile
                });
            _policyRepositoryMock
                .Setup(x => x.GetFundingStreamPeriod(It.Is<string>(s => s == "ASTO1516")))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnActuals
                });
            _policyRepositoryMock
                .Setup(x => x.GetFundingStreamPeriod(It.Is<string>(s => s == "LEVY1799")))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnInstruction
                });

            _busMock = new Mock<IBus>();

            _paymentScheduleCreatorMock = new Mock<IPaymentScheduleCreator>();
            _paymentScheduleCreatorMock.Setup(c => c.CreatePaymentScheduleFromAllocation(It.IsAny<allocationType>()))
                .Returns(new PaymentScheduleWithPayments(null, null));

            _paymentManagerMock = new Mock<IPaymentManager>();
            _paymentManagerMock.Setup(pm => pm.CalculatePaymentScheduleOnApproval(It.IsAny<allocationType>()))
                .Returns(new CrossDomain.Integration.Entities.PaymentSchedule.Allocation
                {
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 1
                        }
                    }
                });
            _paymentManagerMock.SetupGet(pm => pm.UpdatedDeliverablePayments).Returns(new List<DeliverablePayment>());

            Mock<IActualValueNullResetService> actualValueNullResetServiceMock = new Mock<IActualValueNullResetService>();
            actualValueNullResetServiceMock.Setup(m =>
                    m.ConditionallyResetActualValuesToNullOnApproval(It.IsAny<PaymentSchedule.Allocation>(), It.IsAny<List<DeliverablePayment>>()))
                .Returns((PaymentSchedule.Allocation a, List<DeliverablePayment> dps) =>
                    new PaymentScheduleAllocationDeliverablePayments(a, dps));

            _dateProviderMock = new Mock<IDate>();

            _allocationDeliveryCommencedHandler = new AllocationDeliveryCommencedHandler(
                Mock.Of<ILogger>(),
                _paymentManagerMock.Object,
                _policyRepositoryMock.Object,
                _busMock.Object,
                paymentScheduleServiceMock.Object,
                _paymentScheduleCreatorMock.Object,
                _dateProviderMock.Object,
                actualValueNullResetServiceMock.Object,
                Mock.Of<IActualVolumeService>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventIfPayOnProfileFundingStreamPeriod()
        {
            // act
            _allocationDeliveryCommencedHandler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = TestAllocation.Create("ASC1516")
            });

            // assert
            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.AtLeastOnce, "PaymentScheduleEvent was not published.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventIfPayOnActualsFundingStreamPeriod()
        {
            // act
            _allocationDeliveryCommencedHandler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = TestAllocation.Create("ASTO1516")
            });

            // assert
            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.AtLeastOnce, "PaymentScheduleEvent was not published.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldNotPublishPaymentScheduleEventIfPayOnInstructionFundingStreamPeriod_NewContract()
        {
            // arrange
            var allocation = TestAllocation.Create("LEVY1799");
            allocation.contractReference.contractVersionNumber = 1;

            // act
            _allocationDeliveryCommencedHandler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation
            });

            // assert
            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Never, "PaymentScheduleEvent was published.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventIfPayOnInstructionFundingStreamPeriod_ContractAmended()
        {
            // arrange
            var allocation = TestAllocation.Create("LEVY1799");
            allocation.contractReference.contractVersionNumber = 2;

            // act
            _allocationDeliveryCommencedHandler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation
            });

            // assert
            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Once, "PaymentScheduleEvent was not published.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldNotRecalculatePaymentsWhenFundingStreamPeriodActivityClosed()
        {
            // arrange
            _policyRepositoryMock
                .Setup(m => m.GetFundingStreamPeriod(It.Is<string>(s => s == "INACTIVE-FSP")))
                .Returns(new PolicyFundingStreamPeriod
                {
                    ActivityCloseDate = DateTime.UtcNow.AddDays(-1).Date
                });

            _dateProviderMock.Setup(m => m.GetCalculationDate()).Returns(DateTime.UtcNow);

            // act
            _allocationDeliveryCommencedHandler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = TestAllocation.Create(fspcode: "INACTIVE-FSP")
            });

            // assert, rather weakly, that we took the expected path thru the code for an inactive FSP and did not invoke OPA
            _paymentManagerMock.Verify(m => m.CalculatePaymentScheduleOnApproval(It.IsAny<allocationType>()), Times.Never);
            _paymentScheduleCreatorMock.Verify(m => m.CreatePaymentScheduleFromAllocation(It.IsAny<allocationType>()), Times.Once);
        }
    }
}