namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using CrossDomain.Integration.Events;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using UnitTests.Common;

    [TestClass]
    public class DeliveryAllocationToPaymentScheduleAllocationTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliveryAllocationToPaymentScheduleAllocationTransformer_ToPaymentScheduleAllocation_ShouldReturnExpectedValues()
        {
            // arrange
            AllocationDeliveryCommencedEvent allocationDeliveryCommencedEvent = TestResource.FromJson<AllocationDeliveryCommencedEvent>(
                "SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Resources",
                "AllocationDeliveryCommencedEvent_LEVY1799.json");

            // act
            Allocation paymentScheduleAllocation = DeliveryAllocationToPaymentScheduleAllocationTransformer.ToPaymentScheduleAllocation(allocationDeliveryCommencedEvent.Allocation);

            // assert
            Assert.AreEqual("LEVY-14576", paymentScheduleAllocation.AllocationNumber, "Incorrect Allocation Number returned");
            Assert.AreEqual("APPLEVY-14576", paymentScheduleAllocation.ContractNumber, "Incorrect Contract Number returned");
            Assert.AreEqual(1, paymentScheduleAllocation.ContractVersionNumber, "Incorrect Contract Version Number returned");
            Assert.AreEqual(1, paymentScheduleAllocation.VersionNumber, "Incorrect Version Number returned"); 
            Assert.AreEqual("LEVY1799", paymentScheduleAllocation.FundingStreamPeriodCode, "Incorrect funding Stream Period Code returned");
            Assert.AreEqual("10017106", paymentScheduleAllocation.Organisation.OrganisationIdentifiers.Single(id => id.OrganisationIdentifierName == OrganisationIdentifierOrganisationIdentifierName.UKPRN).OrganisationId, "Incorrect UKPRN returned");

            Assert.IsNotNull(paymentScheduleAllocation.AllocationDeliverables, "No Allocation Deliverables returned");
            Assert.AreEqual(12, paymentScheduleAllocation.AllocationDeliverables.Count, "Incorrect number of Allocation Deliverables");

            AllocationDeliverable deliverable1 = paymentScheduleAllocation.AllocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == 1);
            Assert.IsNotNull(deliverable1, "Deliverable 1 not present");
            Assert.AreEqual(1, deliverable1.ScheduledPayments.Count, "Incorrect number of scheduled payments for deliverable 1");
            Assert.AreEqual("201705", deliverable1.ScheduledPayments.Single().Period, "Incorrect Scheduled Payment Period for deliverable 1");
            Assert.AreEqual("CM", deliverable1.ScheduledPayments.Single().PeriodTypeCode, "Incorrect Scheduled Payment PeriodType for deliverable 1");
            Assert.AreEqual(0M, deliverable1.ScheduledPayments.Single().PlannedValue, "Incorrect Scheduled Payment PlannedValue for deliverable 1");
            Assert.AreEqual(0, deliverable1.ScheduledPayments.Single().PlannedVolume, "Incorrect Scheduled Payment PlannedVolume for deliverable 1");

            AllocationDeliverable deliverable9 = paymentScheduleAllocation.AllocationDeliverables.SingleOrDefault(ad => ad.DeliverableCode == 9);
            Assert.IsNotNull(deliverable9, "Deliverable 9 not present");
            Assert.AreEqual(1, deliverable9.ScheduledPayments.Count, "Incorrect number of scheduled payments for deliverable 9");
            Assert.AreEqual("201705", deliverable9.ScheduledPayments.Single().Period, "Incorrect Scheduled Payment Period for deliverable 9");
            Assert.AreEqual("CM", deliverable9.ScheduledPayments.Single().PeriodTypeCode, "Incorrect Scheduled Payment PeriodType for deliverable 9");
            Assert.AreEqual(0M, deliverable9.ScheduledPayments.Single().PlannedValue, "Incorrect Scheduled Payment PlannedValue for deliverable 9");
            Assert.AreEqual(0, deliverable9.ScheduledPayments.Single().PlannedVolume, "Incorrect Scheduled Payment PlannedVolume for deliverable 9");
        }
    }
}
