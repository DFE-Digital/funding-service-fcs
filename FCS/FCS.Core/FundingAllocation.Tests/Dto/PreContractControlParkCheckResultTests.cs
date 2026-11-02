namespace FundingAllocation.Tests.Dto
{
    using System.Collections.Generic;
    using FundingAllocation.Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PreContractControlParkCheckResultTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlParkCheckResult_GetParkedAwaitingConfigSubStatus_ShouldReturnSubStatusAwaitingFundingAllocationConfig()
        {
            // arrange
            var fundingId = "fa1";
            var parkCheckResult = new PreContractControlParkCheckResult(new List<DataStore.Model.FundingAllocation>(),
                new List<string>(),
                new List<string>(),
                new List<string>{ fundingId },
                new List<string>(),
                new List<string>(),
                new List<DataStore.Model.FundingAllocation>(),
                new List<string>());

            // act
            var parkedAwaitingConfigSubStatus = parkCheckResult.GetParkedAwaitingConfigSubStatus(fundingId);

            // assert
            Assert.AreEqual("AwaitingFundingAllocationConfig", parkedAwaitingConfigSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlParkCheckResult_GetParkedAwaitingConfigSubStatus_ShouldReturnSubStatusAwaitingContractTypeConfig()
        {
            // arrange
            var fundingId = "fa1";
            var parkCheckResult = new PreContractControlParkCheckResult(new List<DataStore.Model.FundingAllocation>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string> { fundingId },
                new List<string>(),
                new List<DataStore.Model.FundingAllocation>(),
                new List<string>());

            // act
            var parkedAwaitingConfigSubStatus = parkCheckResult.GetParkedAwaitingConfigSubStatus(fundingId);

            // assert
            Assert.AreEqual("AwaitingContractTypeConfig", parkedAwaitingConfigSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlParkCheckResult_GetParkedAwaitingConfigSubStatus_ShouldReturnSubStatusAwaitingFundingLineConfig()
        {
            // arrange
            var fundingId = "fa1";
            var parkCheckResult = new PreContractControlParkCheckResult(new List<DataStore.Model.FundingAllocation>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string> { fundingId },
                new List<DataStore.Model.FundingAllocation>(),
                new List<string>());

            // act
            var parkedAwaitingConfigSubStatus = parkCheckResult.GetParkedAwaitingConfigSubStatus(fundingId);

            // assert
            Assert.AreEqual("AwaitingFundingLineConfig", parkedAwaitingConfigSubStatus);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlParkCheckResult_GetParkedAwaitingConfigSubStatus_ShouldReturnEmptyString()
        {
            // arrange
            var fundingId = "fa1";
            var parkCheckResult = new PreContractControlParkCheckResult(new List<DataStore.Model.FundingAllocation>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>( ),
                new List<DataStore.Model.FundingAllocation>(),
                new List<string>());

            // act
            var parkedAwaitingConfigSubStatus = parkCheckResult.GetParkedAwaitingConfigSubStatus(fundingId);

            // assert
            Assert.AreEqual(string.Empty, parkedAwaitingConfigSubStatus);
        }


    }
}