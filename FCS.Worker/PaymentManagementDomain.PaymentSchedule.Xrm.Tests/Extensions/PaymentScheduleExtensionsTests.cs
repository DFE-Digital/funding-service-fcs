namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    [TestClass]
    public class PaymentScheduleExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSchedule_AreAllDeliverablePeriodsPresent_ShouldReturnTrueWhenDeliverablePeriodssOnPaymentScheduleAreAllPresentInListAndAllAreWithinTheAllocationDateRangeBoundary()
        {
            // arrange
            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    }
                }
            };

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "2"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "2"),
            };

            DateTime allocationStartDate = new DateTime(2018, 08, 01);
            DateTime allocationEndDate = new DateTime(2018, 09, 01);

            // act
            var result = paymentSchedule.AreAllDeliverablePeriodsPresent(deliverablePeriodYears, allocationStartDate, allocationEndDate);

            // assert
            Assert.IsTrue(result, "Incorrect response from AreAllDeliverablePeriodsPresent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSchedule_AreAllDeliverablePeriodsPresent_ShouldReturnTrueWhenDeliverablePeriodsOnPaymentScheduleAreAllPresentInListAndThereAreMoreInTheListOutsideTheAllocationDateRangeBoundary()
        {
            // arrange
            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    }
                }
            };

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 10, periodName: "Oct-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "2"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "2"),
                new DeliverablePeriodYear(period: 10, periodName: "Oct-2018", year: 2018, deliverableCode: "2"),
            };

            DateTime allocationStartDate = new DateTime(2018, 08, 01);
            DateTime allocationEndDate = new DateTime(2018, 09, 01);

            // act
            var result = paymentSchedule.AreAllDeliverablePeriodsPresent(deliverablePeriodYears, allocationStartDate, allocationEndDate);

            // assert
            Assert.IsTrue(result, "Incorrect response from AreAllDeliverablePeriodsPresent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSchedule_AreAllDeliverablePeriodsPresent_ShouldReturnTrueWhenDeliverablePeriodsOnPaymentScheduleAreAllPresentInListAndThereAreMoreInThePaymentScheduleOutsideTheAllocationDateRangeBoundary()
        {
            // arrange
            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"},
                            new ScheduledPayment {Period = "201810"}
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"},
                            new ScheduledPayment {Period = "201810"}
                        }
                    }
                }
            };

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "2"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "2"),
            };

            DateTime allocationStartDate = new DateTime(2018, 08, 01);
            DateTime allocationEndDate = new DateTime(2018, 09, 01);

            // act
            var result = paymentSchedule.AreAllDeliverablePeriodsPresent(deliverablePeriodYears, allocationStartDate, allocationEndDate);

            // assert
            Assert.IsTrue(result, "Incorrect response from AreAllDeliverablePeriodsPresent");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSchedule_AreAllDeliverablePeriodsPresent_ShouldReturnFalseWhenDeliverablePeriodsOnPaymentScheduleAreNotAllPresentInListWithinTheDateRangeBoundary()
        {
            // arrange
            SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule.Allocation paymentSchedule = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment {Period = "201808"},
                            new ScheduledPayment {Period = "201809"}
                        }
                    }
                }
            };

            IReadOnlyCollection<DeliverablePeriodYear> deliverablePeriodYears = new List<DeliverablePeriodYear>
            {
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 9, periodName: "Sep-2018", year: 2018, deliverableCode: "1"),
                new DeliverablePeriodYear(period: 8, periodName: "Aug-2018", year: 2018, deliverableCode: "2"),
            };

            DateTime allocationStartDate = new DateTime(2018, 08, 01);
            DateTime allocationEndDate = new DateTime(2018, 09, 01);

            // act
            var result = paymentSchedule.AreAllDeliverablePeriodsPresent(deliverablePeriodYears, allocationStartDate, allocationEndDate);

            // assert
            Assert.IsFalse(result, "Incorrect response from AreAllDeliverablePeriodsPresent");
        }
    }
}
