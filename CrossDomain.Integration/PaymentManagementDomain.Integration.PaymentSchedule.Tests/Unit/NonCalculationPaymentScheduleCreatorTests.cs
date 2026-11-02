namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.AllocationActuals;
    using CrossDomain.Integration.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using Services;
    using UnitTests.Common;

    [TestClass]
    public class NonCalculationPaymentScheduleCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NonCalculationPaymentScheduleCreator_ShouldCreateAPaymentScheduleForNoCalcNoPayPaymentMethod()
        {
            // arrange
            Mock<IPayCalcPolicyQueryRepository> repositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            repositoryMock.Setup(r => r.GetFundingStreamPeriod(It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.NoCalcAndNoPay
                });

            NonCalculationPaymentScheduleCreator scheduleCreator = new NonCalculationPaymentScheduleCreator(prevPaymentScheduleCopier: Mock.Of<IPreviousPaymentScheduleCopier>(),
                payCalcPolicyQueryRepository: repositoryMock.Object,
                deliverablePaymentRepository: null);
            AllocationDeliveryCommencedEvent message = GetAllocationDeliveryCommencedEvent();

            // act
            PaymentScheduleWithPayments paymentScheduleWithPayments = scheduleCreator.CreatePaymentScheduleFromAllocation(message.Allocation);

            // assert
            Assert.IsNotNull(paymentScheduleWithPayments, "The returned value is null");
            Assert.AreEqual(12, paymentScheduleWithPayments.DeliverablePayments.Count, "The are an incorrect number of deliverable payments");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NonCalculationPaymentScheduleCreator_CreatePaymentScheduleFromActuals_ShouldCreateWithDeliverablePaymentsPopulatedWithPlannedValueAndPlannedVolume()
        {
            // arrange
            const string allocationNumber = "NCSP-197";
            const int versionNumber = 1;
            const int plannedValueMultiplyFactor = 100;
            const int plannedVolumeMultiplyFactor = 50;

            Mock<IPayCalcPolicyQueryRepository> repositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            repositoryMock.Setup(r => r.GetFundingStreamPeriod(It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    PaymentMethod = PaymentMethod.PayOnActuals
                });

            AllocationActualsVerified message = GetAllocationActualsVerified();
            IReadOnlyCollection<DeliverablePayment> deliverablePayments = message.AllocationActuals.ActualsSummary.Select(act => CreateDeliverablePayment(act, allocationNumber, versionNumber)).ToList();

            // give them all a planned value
            deliverablePayments.ForEach(dp => dp.PlannedValue = dp.DeliverableCode * plannedValueMultiplyFactor);
            // and a planned volume
            deliverablePayments.ForEach(dp => dp.PlannedVolume = dp.DeliverableCode * plannedVolumeMultiplyFactor);

            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock = new Mock<IDeliverablePaymentRepository>();
            deliverablePaymentRepositoryMock.Setup(
                dpRep => dpRep.GetDeliverablePaymentsForAllocation(It.IsAny<string>(), It.IsAny<int>()))
                .Returns(deliverablePayments);

            NonCalculationPaymentScheduleCreator scheduleCreator = new NonCalculationPaymentScheduleCreator(
                prevPaymentScheduleCopier: Mock.Of<IPreviousPaymentScheduleCopier>(),
                payCalcPolicyQueryRepository: repositoryMock.Object,
                 deliverablePaymentRepository: deliverablePaymentRepositoryMock.Object);

            // act
            PaymentScheduleWithPayments paymentScheduleWithPayments = scheduleCreator.CreatePaymentScheduleFromActuals(message.AllocationActuals);
          
            // assert
            Assert.IsTrue(paymentScheduleWithPayments.DeliverablePayments.All(dp => dp.PlannedValue.HasValue), "The planned value has not been set");

            Assert.IsTrue(paymentScheduleWithPayments.DeliverablePayments.All(dp => dp.PlannedValue == dp.DeliverableCode * plannedValueMultiplyFactor), "The planned values has not been set correctly");

            Assert.IsTrue(paymentScheduleWithPayments.DeliverablePayments.All(dp => dp.PlannedVolume.HasValue), "The planned volume has not been set");

            Assert.IsTrue(paymentScheduleWithPayments.DeliverablePayments.All(dp => dp.PlannedVolume == dp.DeliverableCode * plannedVolumeMultiplyFactor), "The planned volumes has not been set correctly");
        }

        private DeliverablePayment CreateDeliverablePayment(ActualsSummaryType actualsSummaryType, string allocationNumber, int version)
        {
            return new DeliverablePayment
            {
                AllocationNumber = allocationNumber,
                VersionNumber = version,
                DeliverableCode = actualsSummaryType.DeliverableCode,
                Period = actualsSummaryType.Period,
            };
        }

        private AllocationDeliveryCommencedEvent GetAllocationDeliveryCommencedEvent()
        {
            return
                TestResource.FromJson<AllocationDeliveryCommencedEvent>(
                    "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                    "Resources.AllocationDeliveryCommencedEvent.json");
        }

        private AllocationActualsVerified GetAllocationActualsVerified()
        {
            return
                TestResource.FromJson<AllocationActualsVerified>(
                    "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests",
                    "Resources.AllocationActualsVerified_NCSP-197.json");
        }
    }
}
