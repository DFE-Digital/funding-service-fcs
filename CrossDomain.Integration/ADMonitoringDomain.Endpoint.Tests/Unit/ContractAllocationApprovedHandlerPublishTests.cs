extern alias Entities;

namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System;
    using BusinessLogic;
    using DataStore.Model;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities;
    using Entities::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaySchedAllocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using AggregatedAllocation = Entities::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation;

    [TestClass]
    public class ContractAllocationApprovedHandlerPublishTests
    {
        private const string Allocation = "A101";
        private const string Category = "NewContractAllocationApproved";

        private Mock<ILogger> _logger;
        private Mock<IAllocationDeliveryMonitoringRepository> _repo;
        private Mock<IAllocationDeliveryPerformanceMapper> _mapper;
        private Mock<IAtomGenerator> _atom;
        private ContractAllocationApprovedHandler _handler;

        [TestInitialize]
        public void Setup()
        {
            _logger = new Mock<ILogger>();
            _repo = new Mock<IAllocationDeliveryMonitoringRepository>();
            _mapper = new Mock<IAllocationDeliveryPerformanceMapper>();
            _atom = new Mock<IAtomGenerator>();
            var dateService = new Mock<IDate>();

            _repo.Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mapper.Setup(m => m.Map(It.IsAny<AllocationDeliveryCommencedEvent>(), It.IsAny<PaymentScheduleEvent>(), It.IsAny<PaymentAggregatedEvent>(), It.IsAny<ConnectionInfo>()))
                .Returns(new AllocationDeliveryPerformance { contractAllocationNumber = Allocation });

            _handler = new ContractAllocationApprovedHandler(
                _logger.Object, _repo.Object, _mapper.Object, dateService.Object, _atom.Object, Mock.Of<ISessionConnectionFactory>());
        }

        private static PaymentAggregatedEvent NewAggregated() =>
            new PaymentAggregatedEvent { Allocation = new AggregatedAllocation { AllocationNumber = Allocation, VersionNumber = 1 } };

        private void SetupEntity(string eventName, AllocationDeliveryEventReceived entity)
        {
            _repo.Setup(r => r.GetAllocationDeliveryEventReceivedEntity(Allocation, 1, Category, eventName, It.IsAny<ConnectionInfo>()))
                .Returns(entity);
        }

        private static AllocationDeliveryEventReceived Entity(object obj = null, string xml = null) =>
            new AllocationDeliveryEventReceived { Object = obj, SerializedXml = xml };

        private void Handle(PaymentAggregatedEvent message) =>
            _handler.Handle(message, new TestableMessageHandlerContext()).Wait();

        private void VerifyPublished(Times times)
        {
            _mapper.Verify(m => m.Map(It.IsAny<AllocationDeliveryCommencedEvent>(), It.IsAny<PaymentScheduleEvent>(), It.IsAny<PaymentAggregatedEvent>(), It.IsAny<ConnectionInfo>()), times);
            _repo.Verify(r => r.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), AllocationDeliveryEntryCategory.NewContractAllocationApproved, It.IsAny<ConnectionInfo>()), times);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllThreeEventsStored_MapsAndStoresPerformanceEvent()
        {
            var commenced = new AllocationDeliveryCommencedEvent();
            var schedule = new PaymentScheduleEvent();
            var aggregated = NewAggregated();
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), Entity(commenced));
            SetupEntity(nameof(PaymentScheduleEvent), Entity(schedule));
            SetupEntity(nameof(PaymentAggregatedEvent), Entity(aggregated));

            Handle(aggregated);

            _mapper.Verify(m => m.Map(commenced, schedule, aggregated, It.IsAny<ConnectionInfo>()), Times.Once);
            VerifyPublished(Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllThreeEventsStoredAsXml_AreDeserialisedBeforeMapping()
        {
            var aggregated = NewAggregated();
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), Entity(xml: new AllocationDeliveryCommencedEvent().SerializeToXml()));
            SetupEntity(nameof(PaymentScheduleEvent), Entity(xml: new PaymentScheduleEvent().SerializeToXml()));
            SetupEntity(nameof(PaymentAggregatedEvent), Entity(xml: aggregated.SerializeToXml()));

            Handle(aggregated);

            _mapper.Verify(m => m.Map(
                It.IsNotNull<AllocationDeliveryCommencedEvent>(),
                It.IsNotNull<PaymentScheduleEvent>(),
                It.IsNotNull<PaymentAggregatedEvent>(),
                It.IsAny<ConnectionInfo>()), Times.Once);
            VerifyPublished(Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CommencedEventMissing_DoesNotPublish()
        {
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), null);

            Handle(NewAggregated());

            VerifyPublished(Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleEventMissing_DoesNotPublish()
        {
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), Entity(new AllocationDeliveryCommencedEvent()));
            SetupEntity(nameof(PaymentScheduleEvent), null);

            Handle(NewAggregated());

            VerifyPublished(Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentAggregatedEventMissing_DoesNotPublish()
        {
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), Entity(new AllocationDeliveryCommencedEvent()));
            SetupEntity(nameof(PaymentScheduleEvent), Entity(new PaymentScheduleEvent()));
            SetupEntity(nameof(PaymentAggregatedEvent), null);

            Handle(NewAggregated());

            VerifyPublished(Times.Never());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleEvent_NewContractPayOnProfile_StoresPayloadAndPublishesWhenAllPresent()
        {
            var schedule = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new PaySchedAllocation { AllocationNumber = Allocation, ContractVersionNumber = 1 }
            };
            SetupEntity(nameof(AllocationDeliveryCommencedEvent), Entity(new AllocationDeliveryCommencedEvent()));
            SetupEntity(nameof(PaymentScheduleEvent), Entity(schedule));
            SetupEntity(nameof(PaymentAggregatedEvent), Entity(NewAggregated()));

            _handler.Handle(schedule, new TestableMessageHandlerContext()).Wait();

            _repo.Verify(r => r.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), typeof(PaymentScheduleEvent)), Times.Once);
            VerifyPublished(Times.Once());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleEvent_AmendedExternallyPaidFromCommenced_GeneratesAtomFeed()
        {
            _repo.Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);
            var schedule = new PaymentScheduleEvent
            {
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced,
                PaymentScheduleAllocation = new PaySchedAllocation { AllocationNumber = Allocation, ContractVersionNumber = 2 }
            };

            _handler.Handle(schedule, new TestableMessageHandlerContext()).Wait();

            _atom.Verify(a => a.GenerateAtomFeed(Allocation, 2, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, It.IsAny<ConnectionInfo>()), Times.Once);
        }
    }
}
