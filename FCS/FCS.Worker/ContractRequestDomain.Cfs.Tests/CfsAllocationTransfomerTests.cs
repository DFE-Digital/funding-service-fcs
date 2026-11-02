namespace ContractRequestDomain.Cfs.Tests
{
    using ContractRequestDomain.Cfs.Detail.Services;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using UnitTests.Common;
    using System.Linq;

    [TestClass]
    public class CfsAllocationTransfomerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CfsAllocationTransfomer_ShouldTransformJsonStringToAllocation()
        {
            // arrange
            string jsonStringAllocation = TestResource.AsString("ContractRequestDomain.Cfs.Tests", "Resources.cfs_allocation.json");

            // act
            Allocation cfsAllocation = CfsAllocationTransfomer.TransformToAllocation(jsonStringAllocation);

            // assert
            Assert.AreEqual(12345678, cfsAllocation.Ukprn, "The ukprn is not set");
            Assert.AreEqual(2, cfsAllocation.AllocationPeriods.Count, "The number of AllocationPeriods is not correct");
            Assert.AreEqual(1, cfsAllocation.AllocationPeriods.Count(ap => ap.Month == 10), "The October of AllocationPeriod is not found");
            Assert.AreEqual(1, cfsAllocation.AllocationPeriods.Count(ap => ap.Month == 4), "The April of AllocationPeriod is not found");
            Assert.AreEqual(1, cfsAllocation.AllocationPeriods.Count(ap => ap.Period == "Oct-18"), "The Oct-18 period is not found");
            Assert.AreEqual(1, cfsAllocation.AllocationPeriods.Count(ap => ap.Period == "Apr-19"), "The Oct-18 period is not found");
            var octPeriod = cfsAllocation.AllocationPeriods.Single(ap => ap.Month == 10);
            Assert.AreEqual(2018, octPeriod.Year, "The Oct period is for the wrong year");
            Assert.AreEqual(2917M, octPeriod.ProfileValue, "The Oct ProfileValue is for the wrong");

            var aprilPeriod = cfsAllocation.AllocationPeriods.Single(ap => ap.Month == 4);
            Assert.AreEqual(2019, aprilPeriod.Year, "The April period is wrong");
            Assert.AreEqual(2083M, aprilPeriod.ProfileValue, "The April ProfileValue is wrong");
        }
    }
}
