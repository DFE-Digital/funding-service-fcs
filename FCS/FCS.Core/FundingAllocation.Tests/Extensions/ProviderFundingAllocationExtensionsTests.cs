namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using TestHelpers.Extensions;

    [TestClass]
    public class ProviderFundingAllocationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationExtensions_IsMateriallyEquivalentTo_ShouldReturnTrueObjectsAreIdentical()
        {
            // arrange
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingLineCode = "NMSS-002";
            ProviderFundingAllocation providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)>{(202101, 10)});

            ProviderFundingAllocation providerFundingAllocation2 = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId,0, string.Empty, string.Empty)
            };
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });
            // act
            bool isMateriallyEquivalentTo =
                providerFundingAllocation.IsMateriallyEquivalentTo(providerFundingAllocation2);
            // assert
            isMateriallyEquivalentTo.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationExtensions_IsMateriallyEquivalentTo_ShouldReturnFalseWhenExtraNoZeroLinePresent()
        {
            // arrange
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingLineCode = "NMSS-002";
            const string fundingLineCode2 = "NMSS-003";
            ProviderFundingAllocation providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });

            ProviderFundingAllocation providerFundingAllocation2 = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode2)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 1) });
            
            // act
            bool isMateriallyEquivalentTo =
                providerFundingAllocation.IsMateriallyEquivalentTo(providerFundingAllocation2);
            
            // assert
            isMateriallyEquivalentTo.Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationExtensions_IsMateriallyEquivalentTo_ShouldReturnTrueWhenPreviousHasZeroPeriodPresent()
        {
            // arrange
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingLineCode = "NMSS-002";
            ProviderFundingAllocation providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10), (202102, 0) });

            ProviderFundingAllocation providerFundingAllocation2 = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });
            // act
            bool isMateriallyEquivalentTo =
                providerFundingAllocation.IsMateriallyEquivalentTo(providerFundingAllocation2);
            // assert
            isMateriallyEquivalentTo.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationExtensions_IsMateriallyEquivalentTo_ShouldReturnTrueWhenCurrentHasZeroPeriodPresent()
        {
            // arrange
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingLineCode = "NMSS-002";
            ProviderFundingAllocation providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });

            ProviderFundingAllocation providerFundingAllocation2 = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10), (202102, 0) });
            // act
            bool isMateriallyEquivalentTo =
                providerFundingAllocation.IsMateriallyEquivalentTo(providerFundingAllocation2);
            // assert
            isMateriallyEquivalentTo.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationExtensions_IsMateriallyEquivalentTo_ShouldReturnFalseWhenValuesAreSamePeriodsAreDifferent()
        {
            // arrange
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingLineCode = "NMSS-002";
            ProviderFundingAllocation providerFundingAllocation = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 10) });

            ProviderFundingAllocation providerFundingAllocation2 = new ProviderFundingAllocation(providerFundingId, fundingId)
            {
                ProviderFunding = new ProviderFunding(providerFundingId, 0, string.Empty, string.Empty)
            };
            providerFundingAllocation2.AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (202101, 5), (202102, 5) });
            // act
            bool isMateriallyEquivalentTo =
                providerFundingAllocation.IsMateriallyEquivalentTo(providerFundingAllocation2);
            // assert
            isMateriallyEquivalentTo.Should().BeFalse();
        }
    }
}
