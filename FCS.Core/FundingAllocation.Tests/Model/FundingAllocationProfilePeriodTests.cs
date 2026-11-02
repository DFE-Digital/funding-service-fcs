namespace FundingAllocation.Tests.Model
{
    using FundingAllocation.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingAllocationProfilePeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationProfilePeriod_PeriodMonth_ShouldReturnExpectedValue()
        {
            // arrange 
            var fundingAllocationProfilePeriod = new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, -1);
            // act
            var result = fundingAllocationProfilePeriod.PeriodMonth;

            // assert
            Assert.AreEqual(9, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationProfilePeriod_PeriodYear_ShouldReturnExpectedValue()
        {
            // arrange 
            var fundingAllocationProfilePeriod = new FundingAllocationProfilePeriod(string.Empty, string.Empty, 202109, -1);
            // act
            var result = fundingAllocationProfilePeriod.PeriodYear;

            // assert
            Assert.AreEqual(2021, result);
        }
    }
}