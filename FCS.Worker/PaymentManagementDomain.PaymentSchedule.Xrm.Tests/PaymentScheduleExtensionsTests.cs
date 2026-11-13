namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests
{
    extern alias Entity;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    
    using PaymentSchedule.PaymentScheduleXrm.Extensions;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    
    [TestClass]
    public class PaymentScheduleExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleExtensions_ShouldConvertToDeliverablePeriodYears()
        {
            // arrange
            Allocation allocation = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201908"
                            },
                            new ScheduledPayment
                            {
                                Period = "201909"
                            },
                            new ScheduledPayment
                            {
                                Period = "201910"
                            }
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "201908"
                            },
                            new ScheduledPayment
                            {
                                Period = "201909"
                            },
                            new ScheduledPayment
                            {
                                Period = "201910"
                            }
                        }
                    }
                }
            };

            // act
            var deliverablePeriodYears = allocation.ToDeliverablePeriodYears();

            // assert
            Assert.AreEqual(6, deliverablePeriodYears.Count, "The number of deliverable period years is incorrect");
            Assert.AreEqual(2, deliverablePeriodYears.Select(dpy => dpy.DeliverableCode).Distinct().Count(), "The number of deliverable codes is incorrect");
            Assert.AreEqual(1, deliverablePeriodYears.Count(dpy => dpy.DeliverableCode == "1" && dpy.Year == 2019 && dpy.Period == 10), "The deliverable code 1 for 2019 for period 10 is not present");
            Assert.AreEqual(1, deliverablePeriodYears.Count(dpy => dpy.DeliverableCode == "2" && dpy.Year == 2019 && dpy.Period == 10), "The deliverable code 2 for 2019 for period 10 is not present");
        }
    }
}
