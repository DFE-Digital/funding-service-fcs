namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule.PaymentScheduleXrm.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationDeliverableExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliverableExtensions_ShouldGetDefaultScheduledPayments()
        {
            // arrange
            DateTime allocationStart = new DateTime(2019, 8, 1, 0, 0, 0, DateTimeKind.Utc);
            DateTime allocationEnd = new DateTime(2020, 7, 31, 0, 0, 0, DateTimeKind.Utc);

            AllocationDeliverable allocationDeliverable = new AllocationDeliverable();
            List<string> periods = new List<string> { "201908", "201909", "201910", "201911", "201912", "202001", "202002", "202003", "202004", "202005", "202006", "202007" };

            // act
            List<ScheduledPayment> scheduledPayments = allocationDeliverable.GetDefaultScheduledPayments(periods);
            
            // assert
            Assert.AreEqual(12, scheduledPayments.Count, "The number of periods is incorrect");
            
            Assert.IsTrue( periods.All(pExpected => scheduledPayments.Select(p => p.Period).Contains(pExpected)), "One of more of the periods is wrong");
        }
    }
}
