namespace FundingAllocation.Tests.Extensions
{
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingIdExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingIdExtensions_ToDecimal_ShouldReturnADecimal()
        {
            // arrange
            const string fundingIdVersion = "4_12";

            // act
            var assertDecimalValue = fundingIdVersion.ToDecimal();

            // assert
            assertDecimalValue.Should().Be(4.12m);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingIdExtensions_ToFundingIdInfo_ShouldReturnFundingIdInfo()
        {
            // arrange
            const string fundingIdName = "1619-AS-2021-Contract-Provider-10014005";
            const string versionSuffix = "-4_6";
            const string fundingId = fundingIdName + versionSuffix;
            const decimal expectedVersion = 4.06m;

            // act
            var fundingIdInfo = fundingId.ToFundingIdInfo();

            // assert
            fundingIdInfo.FundingId.Should().Be(fundingId);
            fundingIdInfo.FundingIdName.Should().Be(fundingIdName);
            fundingIdInfo.FundingIdVersion.Should().Be(expectedVersion);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingIdExtensions_RemoveVersionFromId_ShouldReturnFundingIdInfo()
        {
            // arrange
            const string fundingAllocationName = "1619-AS-2021-Contract-Provider-10014005";
            const string versionSuffix = "-4_6";
            const string fundingId = fundingAllocationName + versionSuffix;

            // act
            var returnedFundingAllocationName = fundingId.RemoveVersionFromId();

            // assert
            returnedFundingAllocationName.Should().Be(fundingAllocationName);
        }
    }
}