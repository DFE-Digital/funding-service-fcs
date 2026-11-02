namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using BusinessLogic;
    using BusinessLogic.Services;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Events;
    using Framework.Logging.Interfaces;
    using Handlers;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using PaymentManagementDomain.PaymentSchedule.DataStore;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore;
    using PolicyCache.DataStore.Repositories;
    using RulesEngine;
    using Services;
    using UnitTests.Common;

    [TestClass]
    public class AllocationDeliveryCommencedHandlerPerformanceTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AllocationDeliveryCommencedHandler_ShouldHandleInAReasonableTime()
        {
            AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent = GetEventFromFile();

            using (var paymentManagementPC = new PaymentManagementPolicyContext())
            using (var context = new PaymentSchedulePolicyContext())
            {
                PayCalcPolicyQueryRepository payCalcPolicyQueryRepository = PayCalcPolicyQueryRepository.CreateInstance(paymentManagementPC);
                AllocationRepository allocationRepository = new AllocationRepository(context);
                DeliverablePaymentRepository deliverablePaymentRepository = new DeliverablePaymentRepository(context);

                AllocationDeliveryCommencedHandler handler = new AllocationDeliveryCommencedHandler(Mock.Of<ILogger>(),
                    new PaymentManager
                    {
                        AllocationRepository = allocationRepository,
                        DateManager = new MyDateProvider(new DateTime(2017, 07, 31, 0, 0, 0, DateTimeKind.Utc)),
                        PaymentSchedulePolicyContext = context,
                        Logger = Mock.Of<ILogger>(),
                        RulesEngine = new RulesEngine { StorageWrapper = Mock.Of<IStorageWrapper>() },
                        PublishedPayableFcrAllocationRepository = new PublishedPayableFcrAllocationRepository(context),
                        PayCalcPolicyQueryRepository = payCalcPolicyQueryRepository,
                        DeliverablePaymentRepository = deliverablePaymentRepository
                    },
                    payCalcPolicyQueryRepository,
                    new Mock<IBus>().Object,
                    new PaymentScheduleService(new AllocationRepository(context),
                    new ProvisionIdentifierRepository(context),
                    new OrganisationIdentifierRepository(context), new DeliverablePaymentRepository(context), Mock.Of<ILogger>()),
                    new NonCalculationPaymentScheduleCreator(new PreviousPaymentScheduleCopier(new DeliverablePaymentRepository(context)), payCalcPolicyQueryRepository, new DeliverablePaymentRepository(context)),
                    Mock.Of<IDate>(),
                    new ActualValueNullResetService(allocationRepository, deliverablePaymentRepository),
                    Mock.Of<IActualVolumeService>()
               );

                handler.Handle(allocationDeliveryCommencedEvent);
            }
        }

        private AllocationDeliveryCommencedEvent GetEventFromFile()
        {
            return TestResource.FromJson<AllocationDeliveryCommencedEvent>("SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
              "Resources.inputMessage.json");
        }

        private class MyDateProvider : IDate
        {
            private readonly DateTime _date;

            public MyDateProvider(DateTime date)
            {
                _date = date;
            }

            public DateTime GetCalculationDate()
            {
                return _date;
            }

            public DateTime GetCalculationDateWithKey(string key)
            {
                return _date;
            }
        }
    }
}
