namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.Integration.PaymentSchedule.Extensions;
    using PaymentSchedule.DataStore.Model;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    [TestClass]
    public class DeliverablePaymentListExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverablePaymentListExtensions_ShouldMap()
        {
            const string allocationNumber = "test a";
            const string fsp = "fsp1";
            const string contractNumber = "contractNumber";

            // arrange
            IReadOnlyCollection<DeliverablePayment> deliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    DeliverableCode = 1,
                    ActualValue = 11,
                    ActualVolume = 12,
                    AllocationNumber = allocationNumber,
                    BalancingPaymentAmount = 13,
                    CappedPaymentAmount = 14,
                    CollectionReturnCode = "RC",
                    NetPaymentAmount = 15,
                    Period = "201808",
                    PeriodTypeCode = PeriodTypeCode.CM,
                    PlannedValue = 16,
                    PlannedVolume = 17,
                    ProfilePaymentAmount = 18,
                    ReconciliationPaymentAmount = 19,
                    VersionNumber = 1
                },
                new DeliverablePayment
                {
                    DeliverableCode = 1,
                    ActualValue = 21,
                    ActualVolume = 22,
                    AllocationNumber = allocationNumber,
                    BalancingPaymentAmount = 23,
                    CappedPaymentAmount = 24,
                    CollectionReturnCode = "RC",
                    NetPaymentAmount = 25,
                    Period = "201809",
                    PeriodTypeCode = PeriodTypeCode.CM,
                    PlannedValue = 26,
                    PlannedVolume = 27,
                    ProfilePaymentAmount = 28,
                    ReconciliationPaymentAmount = 29,
                    VersionNumber = 1
                },
                new DeliverablePayment
                {
                    DeliverableCode = 2,
                    ActualValue = 31,
                    ActualVolume = 32,
                    AllocationNumber = allocationNumber,
                    BalancingPaymentAmount = 33,
                    CappedPaymentAmount = 34,
                    CollectionReturnCode = "RC",
                    NetPaymentAmount = 35,
                    Period = "201808",
                    PeriodTypeCode = PeriodTypeCode.CM,
                    PlannedValue = 36,
                    PlannedVolume = 37,
                    ProfilePaymentAmount = 38,
                    ReconciliationPaymentAmount = 39,
                    VersionNumber = 1
                }

            };

            // act
            Allocation allocationPaymentSchedule = deliverablePayments.ToPaymentSchedule(fsp, contractNumber, new Organisation());

            // assert
            Assert.AreEqual(2, allocationPaymentSchedule.AllocationDeliverables.Count, "The number of deliverables is incorrect");
            Assert.IsTrue(deliverablePayments.Select(dp => dp.DeliverableCode)
                .All(dc => allocationPaymentSchedule.AllocationDeliverables
                    .Select(d => d.DeliverableCode).Contains(dc)), "The deliverables codes are not all there");

            int numPeriodsForDeliverableOne = allocationPaymentSchedule.AllocationDeliverables
                .Single(d => d.DeliverableCode == 1).ScheduledPayments.Count;
            Assert.AreEqual(2, numPeriodsForDeliverableOne, "The number of periods on deliverable one is incorrect");

            ScheduledPayment scheduledPaymentForDeliverableOnePeriod201809 = allocationPaymentSchedule.AllocationDeliverables.Single(d => d.DeliverableCode == 1).ScheduledPayments
                .Single(sp => sp.Period == "201809");
            DeliverablePayment deliverablePayment = deliverablePayments.Single(dp => dp.DeliverableCode == 1 && dp.Period == "201809");

            Assert.AreEqual(deliverablePayment.ActualValue, scheduledPaymentForDeliverableOnePeriod201809.ActualValue, "The actualValue is incorrect");
            Assert.AreEqual(deliverablePayment.ActualVolume, scheduledPaymentForDeliverableOnePeriod201809.ActualVolume, "The ActualVolume is incorrect");
            Assert.AreEqual(deliverablePayment.BalancingPaymentAmount, scheduledPaymentForDeliverableOnePeriod201809.BalancingPaymentAmount, "The BalancingPaymentAmount is incorrect");
            Assert.AreEqual(deliverablePayment.CappedPaymentAmount, scheduledPaymentForDeliverableOnePeriod201809.CappedPaymentAmount, "The CappedPaymentAmount is incorrect");
            Assert.AreEqual(deliverablePayment.NetPaymentAmount, scheduledPaymentForDeliverableOnePeriod201809.NetPaymentAmount, "The NetPaymentAmount is incorrect");
            Assert.AreEqual(deliverablePayment.PlannedValue, scheduledPaymentForDeliverableOnePeriod201809.PlannedValue, "The PlannedValue is incorrect");
            Assert.AreEqual(deliverablePayment.PlannedVolume, scheduledPaymentForDeliverableOnePeriod201809.PlannedVolume, "The PlannedVolume is incorrect");

            int numPeriodsForDeliverableTwo = allocationPaymentSchedule.AllocationDeliverables
                .Single(d => d.DeliverableCode == 2).ScheduledPayments.Count;
            Assert.AreEqual(1, numPeriodsForDeliverableTwo, "The number of periods on deliverable two is incorrect");

            Assert.AreEqual(allocationNumber, allocationPaymentSchedule.AllocationNumber, "The allocation number is not correct");
            Assert.AreEqual(contractNumber, allocationPaymentSchedule.ContractNumber, "The contract number is not correct");
        }
    }
}