namespace FundingAllocation.Tests.Extensions
{
    using System;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DateTimeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DateTimeExtensions_ToPeriod_ShouldReturnFormattedNumber()
        {
            DateTime date = new DateTime(2020, 8, 1, 0, 0, 0, DateTimeKind.Utc);

            // act
            int period = date.ToPeriod();

            // assert
            Assert.AreEqual(202008, period);
        }
    }
}
