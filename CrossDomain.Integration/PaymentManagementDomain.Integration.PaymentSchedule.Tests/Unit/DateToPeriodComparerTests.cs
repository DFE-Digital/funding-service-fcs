namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Unit
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration;

    [TestClass]
    public class DateToPeriodComparerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DateToPeriodComparer_ShouldReturnTrueWhenPeriodWithinRange()
        {
            DateTime startDate = new DateTime(2015, 8, 1);
            DateTime endDate = new DateTime(2016, 7, 31);

            Assert.IsTrue(DateToPeriodComparer.IsPeriodWithinDateRange("201508", startDate, endDate), "Period 201508 is within range");
            Assert.IsTrue(DateToPeriodComparer.IsPeriodWithinDateRange("201607", startDate, endDate), "Period 201607 is within range");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void DateToPeriodComparer_ShouldReturnFalseWhenPeriodWithinRange()
        {
            DateTime startDate = new DateTime(2015, 1, 1);
            DateTime endDate = new DateTime(2015, 12, 31);

            Assert.IsFalse(DateToPeriodComparer.IsPeriodWithinDateRange("201412", startDate, endDate), "Period 201412 is not within range");
            Assert.IsFalse(DateToPeriodComparer.IsPeriodWithinDateRange("201601", startDate, endDate), "Period 201601 is not within range");
        }
    }
}
