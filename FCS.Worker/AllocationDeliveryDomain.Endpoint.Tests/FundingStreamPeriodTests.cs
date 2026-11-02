namespace AllocationDeliveryDomain.Endpoint.Tests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class FundingStreamPeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_IsFspActive_ShouldReturnTrueWhenActivityCloseNotSet()
        {
            // arrange
            FundingStreamPeriod  fsp = new FundingStreamPeriod();

            // act
            bool result = fsp.IsFspActive(DateTime.Now);

            // assert
            Assert.AreEqual(true, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_IsFspActive_ShouldReturnTrueWhenActivityCloseSetButAfterTheCurrentDate()
        {
            // arrange
            DateTime now = DateTime.Now.Date;
            FundingStreamPeriod fsp = new FundingStreamPeriod
            {
                ActivityCloseDate = now.AddDays(1).Date
            };

            // act
            bool result = fsp.IsFspActive(now);

            // assert
            Assert.AreEqual(true, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_IsFspActive_ShouldReturnFalseWhenActivityCloseSetButAfterTheSameAsCurrentDate()
        {
            // arrange
            DateTime now = DateTime.Now.Date;
            FundingStreamPeriod fsp = new FundingStreamPeriod
            {
                ActivityCloseDate = now
            };

            // act
            bool result = fsp.IsFspActive(now);

            // assert
            Assert.AreEqual(false, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingStreamPeriod_IsFspActive_ShouldReturnFalseWhenActivityCloseSetButEarlierThanCurrentDate()
        {
            // arrange
            DateTime now = DateTime.Now.Date;
            FundingStreamPeriod fsp = new FundingStreamPeriod
            {
                ActivityCloseDate = now.AddDays(-1).Date
            };

            // act
            bool result = fsp.IsFspActive(now);

            // assert
            Assert.AreEqual(false, result);
        }
    }
}
