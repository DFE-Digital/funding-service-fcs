namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using BusinessLogic.Services;
    using Castle.Windsor;
    using CrossDomain.Integration.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PolicyCache.DataStore.Repositories;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Events;
    using Framework.Logging;
    using Framework.Logging.Interfaces;
    using BusinessLogic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using CrossDomain.Integration.Entities.Data;
    using Dtos;
    using Handlers;
    using IoC;
    using Utils;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PolicyCache.DataStore.Model;
    using UnitTests.Common;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore;
    using Services;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationDeliveryCommencedHandlerIntegrationTests
    {
        private const string AllocationNumber = "ADCHANDLERALLOC1";
        private Mock<IBus> _busMock;
        private AllocationDeliveryCommencedHandler _handler;

        private void Setup()
        {
            Cleanup();

            Mock<IMessageContext> messageContextMock = new Mock<IMessageContext>();
            messageContextMock
                .SetupGet(p => p.Headers)
                .Returns(() => new Dictionary<string, string> {{Headers.CorrelationId, Guid.NewGuid().ToString()}});

            _busMock = new Mock<IBus>();
            _busMock.SetupGet(p => p.CurrentMessageContext).Returns(() => messageContextMock.Object);

            Mock<IDate> dateMock = new Mock<IDate>();
            dateMock.Setup(x => x.GetCalculationDate()).Returns(new DateTime(2016, 11, 01));
            dateMock.Setup(x => x.GetCalculationDateWithKey(It.IsAny<string>())).Returns(new DateTime(2016, 11, 01));

            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            Mock<IPaymentScheduleCreator> paymentScheduleCreator = new Mock<IPaymentScheduleCreator>();
            paymentScheduleCreator.Setup(c => c.CreatePaymentScheduleFromAllocation(It.IsAny<allocationType>()))
                .Returns(new PaymentScheduleWithPayments(null, null));

            IPaymentManager paymentManager = container.Resolve<IPaymentManager>();

            Mock<IActualValueNullResetService> actualValueNullResetServiceMock = new Mock<IActualValueNullResetService>();
            actualValueNullResetServiceMock.Setup(m =>
                    m.ConditionallyResetActualValuesToNullOnApproval(It.IsAny<PaymentSchedule.Allocation>(), It.IsAny<List<DeliverablePayment>>()))
                .Returns((PaymentSchedule.Allocation a, List<DeliverablePayment> dps) =>
                    new PaymentScheduleAllocationDeliverablePayments(a, dps));

            ((PaymentManager) paymentManager).DateManager = dateMock.Object;

            _handler = new AllocationDeliveryCommencedHandler(
                container.Resolve<ILogger>(),
                paymentManager,
                container.Resolve<IPayCalcPolicyQueryRepository>(),
                _busMock.Object,
                Mock.Of<IPaymentScheduleService>(),
                paymentScheduleCreator.Object,
                Mock.Of<IDate>(),
                actualValueNullResetServiceMock.Object,
                Mock.Of<IActualVolumeService>());
        }

        public void Cleanup()
        {
            using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            {
                paymentSchedulePolicyContext.OrganisationIdentifiers.RemoveWhere(oi => oi.AllocationNumber == AllocationNumber);
                paymentSchedulePolicyContext.DeliverablePayments.RemoveWhere(dp => dp.AllocationNumber == AllocationNumber);
                paymentSchedulePolicyContext.Allocations.RemoveWhere(m => m.AllocationNumber == AllocationNumber);
                paymentSchedulePolicyContext.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventForPoA()
        {
            Setup();

            allocationType allocation = TestAllocation.Create();
            allocation.contractAllocationNumber = AllocationNumber;

            // ASTO1516 is PoA
            allocation.fundingStreamPeriod.fundingStreamPeriodCode = "ASTO1516";

            var allocationDeliveryEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation,
            };

            _handler.Handle(allocationDeliveryEvent);

            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Once);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void AllocationDeliveryCommencedHandler_ShouldNotPublishPaymentScheduleEventForLevyNewContract()
        {
            Setup();

            allocationType allocation = TestAllocation.Create();
            allocation.contractAllocationNumber = AllocationNumber;

            // LEVY1799 is Levy
            allocation.fundingStreamPeriod.fundingStreamPeriodCode = "LEVY1799";
            allocation.contractReference.contractVersionNumber = 1;

            var allocationDeliveryEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation,
            };

            _handler.Handle(allocationDeliveryEvent);

            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Never);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventForLevyAmendedContract()
        {
            Setup();

            allocationType allocation = TestAllocation.Create();
            allocation.contractAllocationNumber = AllocationNumber;

            // LEVY1799 is Levy
            allocation.fundingStreamPeriod.fundingStreamPeriodCode = "LEVY1799";
            allocation.contractReference.contractVersionNumber = 2;

            var allocationDeliveryEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation,
            };

            _handler.Handle(allocationDeliveryEvent);

            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Once);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void AllocationDeliveryCommencedHandler_ShouldPublishPaymentScheduleEventForPoP()
        {
            Setup();

            allocationType allocation = TestAllocation.Create();
            allocation.contractAllocationNumber = AllocationNumber;

            // ASC1516 is PoP
            allocation.fundingStreamPeriod.fundingStreamPeriodCode = "ASC1516";

            var allocationDeliveryEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = allocation,
            };

            _handler.Handle(allocationDeliveryEvent);

            _busMock.Verify(x => x.Publish(It.IsAny<PaymentScheduleEvent>()), Times.Once);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void AllocationDeliveryCommencedHandler_ShouldPopulateDeliverablePaymentTableForPayOnInstruction()
        {
            Cleanup();

            AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent = TestResource.FromJson<AllocationDeliveryCommencedEvent>(
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Resources",
                "AllocationDeliveryCommencedEvent_LEVY1799.json");
            allocationDeliveryCommencedEvent.Allocation.contractAllocationNumber = AllocationNumber;

            // arrange
            Mock<IPayCalcPolicyQueryRepository> payCalcPolicyQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriod(It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnInstruction
                });

            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());
            container.BeginScope();

            Mock<IActualValueNullResetService> actualValueNullResetServiceMock = new Mock<IActualValueNullResetService>();
            actualValueNullResetServiceMock.Setup(m =>
                    m.ConditionallyResetActualValuesToNullOnApproval(It.IsAny<PaymentSchedule.Allocation>(), It.IsAny<List<DeliverablePayment>>()))
                .Returns((PaymentSchedule.Allocation a, List<DeliverablePayment> dps) =>
                    new PaymentScheduleAllocationDeliverablePayments(a, dps));

            using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
            {
                IPaymentScheduleCreator paymentScheduleCreator = new NonCalculationPaymentScheduleCreator(
                    new PreviousPaymentScheduleCopier(new DeliverablePaymentRepository(paymentSchedulePolicyContext)),
                    new PayCalcPolicyQueryRepository(paymentManagementPolicyContext, new EntityCache<string, PolicyFundingStreamPeriod>(), null, null), null);
                AllocationDeliveryCommencedHandler handler = new AllocationDeliveryCommencedHandler(
                    Mock.Of<ILogger>(),
                    Mock.Of<IPaymentManager>(),
                    payCalcPolicyQueryRepositoryMock.Object,
                    Mock.Of<IBus>(),
                    container.Resolve<IPaymentScheduleService>(),
                    paymentScheduleCreator,
                    Mock.Of<IDate>(),
                    actualValueNullResetServiceMock.Object,
                    Mock.Of<IActualVolumeService>());

                // act
                handler.Handle(allocationDeliveryCommencedEvent);
            }
              
            // assert
            using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
            {
                Allocation allocation = paymentSchedulePolicyContext.Allocations.SingleOrDefault(a => a.AllocationNumber == AllocationNumber);
                Assert.IsNotNull(allocation, "No allocation found");
                Assert.AreEqual(AllocationNumber, allocation.AllocationNumber, "Incorrect AllocationNumber returned");

                List<DeliverablePayment> deliverablePayments = paymentSchedulePolicyContext.DeliverablePayments.Where(a => a.AllocationNumber == AllocationNumber).ToList();
                Assert.AreEqual(12, deliverablePayments.Count, "Incorrect number of Deliverable Payments returned");
                Assert.IsTrue(deliverablePayments.All(dp => dp.Period == "201705"), "Incorrect Periods returned");

                List<OrganisationIdentifer> organisationIdentifers = paymentSchedulePolicyContext.OrganisationIdentifiers.Where(a => a.AllocationNumber == AllocationNumber).ToList();
                Assert.AreEqual(1, organisationIdentifers.Count, "Incorrect number of organisation identifiers returned");
            }
        }

        // may belong somewhere else - there are already four files for tests for this handler
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryCommencedHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory()));
            container.Register(Component.For<IHandleMessages<AllocationDeliveryCommencedEvent>>()
                .ImplementedBy<AllocationDeliveryCommencedHandler>());
            container.Register(Component.For<IBus>().Instance(Mock.Of<IBus>()));
            container.BeginScope();

            var handler = container.Resolve<IHandleMessages<AllocationDeliveryCommencedEvent>>();

            Assert.IsNotNull(handler, "AllocationDeliveryCommencedHandler did not resolve");
        }
    }
}