namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;

    [TestClass]
    public class EsfAllocationDataTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EsfAllocationData_ShouldReturnTheInvestmentPriorityNumber()
        {
            // arrange
            EsfAllocationData esfAllocationData = new EsfAllocationData
            {
                InvestmentPriority = "1.1 Some string"
            };

            // act
            decimal investmentPriorityNumber = esfAllocationData.InvestmentPriorityNumber;

            // assert
            Assert.AreEqual(1.1M, investmentPriorityNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EsfAllocationData_ShouldReturnRegionTypeTrimmed()
        {
            // arrange
            EsfAllocationData esfAllocationData = new EsfAllocationData
            {
                RegionType = "Less Developed"
            };

            // act
            string regionTypeTrimmed = esfAllocationData.RegionTypeTrimmed;

            // assert
            Assert.AreEqual("LessDeveloped", regionTypeTrimmed);
        }
    }
}
