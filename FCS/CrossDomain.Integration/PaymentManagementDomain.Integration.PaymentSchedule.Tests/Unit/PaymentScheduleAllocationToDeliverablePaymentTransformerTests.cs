namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using Services;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class PaymentScheduleAllocationToDeliverablePaymentTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleAllocationToDeliverablePaymentTransformer_ToDeliverablePayments_ShouldReturnExpectedValues()
        {
            // arrange 
            PaymentSchedule.Allocation paymentScheduleAllocation = new PaymentSchedule.Allocation
            {
                AllocationNumber = "LEVY-123",
                ContractVersionNumber = 1,
                AllocationDeliverables = new List<PaymentSchedule.AllocationDeliverable>
                {
                    new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                        {
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201705",
                                PeriodTypeCode = "LEVY",
                                ActualValue = 1,
                                ActualVolume = 0,
                                PlannedValue = 2,
                                PlannedVolume = 3,
                                BalancingPaymentAmount = 4,
                                CappedPaymentAmount = 5,
                                NetPaymentAmount = 6,
                                ProfilePaymentAmount = 7,
                                ReconciliationPaymentAmount = 8,
                                CollectionReturnCode = "APPS01"
                            },
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201706",
                                PeriodTypeCode = "LEVY",
                                ActualValue = 21,
                                ActualVolume = 10,
                                PlannedValue = 22,
                                PlannedVolume = 23,
                                BalancingPaymentAmount = 24,
                                CappedPaymentAmount = 25,
                                NetPaymentAmount = 26,
                                ProfilePaymentAmount = 27,
                                ReconciliationPaymentAmount = 28,
                                CollectionReturnCode = "APPS01"
                            }
                        }
                    },
                    new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<PaymentSchedule.ScheduledPayment>
                        {
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201705",
                                PeriodTypeCode = "LEVY",
                                ActualValue = 31,
                                ActualVolume = 0,
                                PlannedValue = 32,
                                PlannedVolume = 33,
                                BalancingPaymentAmount = 34,
                                CappedPaymentAmount = 35,
                                NetPaymentAmount = 36,
                                ProfilePaymentAmount = 37,
                                ReconciliationPaymentAmount = 38,
                                CollectionReturnCode = "APPS01"
                            },
                            new PaymentSchedule.ScheduledPayment
                            {
                                Period = "201706",
                                PeriodTypeCode = "LEVY",
                                ActualValue = 41,
                                ActualVolume = 0,
                                PlannedValue = 42,
                                PlannedVolume = 43,
                                BalancingPaymentAmount = 44,
                                CappedPaymentAmount = 45,
                                NetPaymentAmount = 46,
                                ProfilePaymentAmount = 47,
                                ReconciliationPaymentAmount = 48,
                                CollectionReturnCode = "APPS01"
                            }
                        }
                    }
                }
            };

            // act
            IReadOnlyCollection<DeliverablePayment> deliverablePayments =
                PaymentScheduleAllocationToDeliverablePaymentTransformer.ToDeliverablePayments(paymentScheduleAllocation);

            // assert
            Assert.AreEqual(4, deliverablePayments.Count, "Incorrect number of Deliverable Payments returned");

            DeliverablePayment deliverable1Period201705 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 1 && dp.Period == "201705");
            Assert.IsNotNull(deliverable1Period201705, "Deliverable 1, Period 201705 not returned");
            Assert.AreEqual(1, deliverable1Period201705.DeliverableCode, "Incorrect DeliverableCode returned");
            Assert.AreEqual("LEVY-123", deliverable1Period201705.AllocationNumber, "Incorrect Allocation Number returned");
            Assert.AreEqual(1, deliverable1Period201705.VersionNumber, "Incorrect Version Number returned");
            Assert.AreEqual("201705", deliverable1Period201705.Period, "Incorrect Period returned");
            Assert.AreEqual("LEVY", deliverable1Period201705.PeriodTypeCode.ToString(), "Incorrect PeriodTypeCode returned");
            Assert.AreEqual(1, deliverable1Period201705.ActualValue, "Incorrect Actual Value returned");
            Assert.AreEqual(0, deliverable1Period201705.ActualVolume, "Incorrect Actual Volume returned");
            Assert.AreEqual(2, deliverable1Period201705.PlannedValue, "Incorrect Planned Value returned");
            Assert.AreEqual(3, deliverable1Period201705.PlannedVolume, "Incorrect Planned Volume returned");
            Assert.AreEqual(4, deliverable1Period201705.BalancingPaymentAmount, "Incorrect BalancingPaymentAmount returned");
            Assert.AreEqual(5, deliverable1Period201705.CappedPaymentAmount, "Incorrect CappedPaymentAmount returned");
            Assert.AreEqual(6, deliverable1Period201705.NetPaymentAmount, "Incorrect NetPaymentAmount returned");
            Assert.AreEqual(7, deliverable1Period201705.ProfilePaymentAmount, "Incorrect ProfilePaymentAmount returned");
            Assert.AreEqual(8, deliverable1Period201705.ReconciliationPaymentAmount, "Incorrect ReconciliationPaymentAmount returned");
            Assert.AreEqual("APPS01", deliverable1Period201705.CollectionReturnCode, "Incorrect CollectionReturnCode returned");

            DeliverablePayment deliverable1Period201706 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 1 && dp.Period == "201706");
            Assert.IsNotNull(deliverable1Period201706, "Deliverable 1, Period 201706 not returned");
            Assert.AreEqual(1, deliverable1Period201706.DeliverableCode, "Incorrect DeliverableCode returned");
            Assert.AreEqual("LEVY-123", deliverable1Period201706.AllocationNumber, "Incorrect Allocation Number returned");
            Assert.AreEqual(1, deliverable1Period201706.VersionNumber, "Incorrect Version Number returned");
            Assert.AreEqual("201706", deliverable1Period201706.Period, "Incorrect Period returned");
            Assert.AreEqual("LEVY", deliverable1Period201706.PeriodTypeCode.ToString(), "Incorrect PeriodTypeCode returned");
            Assert.AreEqual(21, deliverable1Period201706.ActualValue, "Incorrect Actual Value returned");
            Assert.AreEqual(10, deliverable1Period201706.ActualVolume, "Incorrect Actual Volume returned");
            Assert.AreEqual(22, deliverable1Period201706.PlannedValue, "Incorrect Planned Value returned");
            Assert.AreEqual(23, deliverable1Period201706.PlannedVolume, "Incorrect Planned Volume returned");
            Assert.AreEqual(24, deliverable1Period201706.BalancingPaymentAmount, "Incorrect BalancingPaymentAmount returned");
            Assert.AreEqual(25, deliverable1Period201706.CappedPaymentAmount, "Incorrect CappedPaymentAmount returned");
            Assert.AreEqual(26, deliverable1Period201706.NetPaymentAmount, "Incorrect NetPaymentAmount returned");
            Assert.AreEqual(27, deliverable1Period201706.ProfilePaymentAmount, "Incorrect ProfilePaymentAmount returned");
            Assert.AreEqual(28, deliverable1Period201706.ReconciliationPaymentAmount, "Incorrect ReconciliationPaymentAmount returned");
            Assert.AreEqual("APPS01", deliverable1Period201706.CollectionReturnCode, "Incorrect CollectionReturnCode returned");

            DeliverablePayment deliverable2Period201705 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 2 && dp.Period == "201705");
            Assert.IsNotNull(deliverable2Period201705, "Deliverable 2, Period 201705 not returned");

            DeliverablePayment deliverable2Period201706 = deliverablePayments.SingleOrDefault(dp => dp.DeliverableCode == 2 && dp.Period == "201706");
            Assert.IsNotNull(deliverable2Period201706, "Deliverable 2, Period 201706 not returned");
        }
    }
}
