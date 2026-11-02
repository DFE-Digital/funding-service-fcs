namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using TestHelpers.Extensions;

    [TestClass]
    public class FundingAllocationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_ToDto_ShouldReturnPopulatedDto()
        {
            // arrange
            var fundingAllocation = new FundingAllocation
            (
                "PSG-AY-2021-Payment-AcademyTrust-10000001-1_0",
                "1_0",
                "AY-2021",
                "PSG",
                "12345678",
                100m,
                1,
                1,
                -1,
                1
            );

            var contractItemsMappings = new ContractItemsMappingResult(
                "EDSK",
                "AY2021",
                "16-19ED2021",
                "Contract for Services (ITP)"
            );

            // act
            var dto = fundingAllocation.ToDto(contractItemsMappings);

            // assert
            dto.FundingId.Should().Be(fundingAllocation.FundingId);
            dto.FundingVersion.Should().Be(fundingAllocation.FundingVersion);
            dto.AllocationFundingStream.Should().Be(fundingAllocation.AllocationFundingStream);
            dto.UKPRN.Should().Be(fundingAllocation.UKPRN);
            dto.Value.Should().Be(fundingAllocation.Value);

            dto.FundingType.Should().Be(contractItemsMappings.FundingTypeCode);
            dto.Period.Should().Be(contractItemsMappings.FundingPeriodCode);
            dto.ContractType.Should().Be(contractItemsMappings.ContractType);
            dto.FSPGroup.Should().Be(contractItemsMappings.FSPGroupCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_IsMateriallyEquivalentTo_ShouldReturnTrueWhenEquivalentWhenIdentical()
        {
            // arrange
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingId2 = "NMSS-AY-2021-Contract-Provider-10017562-5_2";
            FundingAllocation fundingAllocation = CreateFundingAllocation(fundingId);
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string providerFundingId2 = "NMSS-AS-2021-10014016-2_0";
            const string fundingLineCode = "NMSS-001";
            fundingAllocation.AddProvider(providerFundingId)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)>{(1, 10)});

            FundingAllocation fa2 = CreateFundingAllocation(fundingId2);
             fa2.AddProvider(providerFundingId2)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (1, 10) });

            // act
            var isEquivalent = fundingAllocation.IsMateriallyEquivalentTo(fa2);
            
            // assert
            isEquivalent.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_IsMateriallyEquivalentTo_ShouldReturnFalseWhenProvidersDiffer()
        {
            // arrange
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingId2 = "NMSS-AY-2021-Contract-Provider-10017562-5_2";
            FundingAllocation fundingAllocation = CreateFundingAllocation(fundingId);
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingLineCode = "NMSS-001";
            fundingAllocation.AddProvider(providerFundingId)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (1, 10) });

            FundingAllocation fundingAllocation2 = CreateFundingAllocation(fundingId2);
            const string providerFundingId2 = "NMSS-AS-2021-10014017-1_0";
            fundingAllocation2.AddProvider(providerFundingId2)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (1, 10) });

            // act
            var isEquivalent = fundingAllocation.IsMateriallyEquivalentTo(fundingAllocation2);

            // assert
            isEquivalent.Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocation_IsMateriallyEquivalentTo_ShouldTrueWhenExtraProviderOnCurrentWithoutPlannedValue()
        {
            // arrange
            const string fundingId = "NMSS-AY-2021-Contract-Provider-10017562-4_4";
            const string fundingId2 = "NMSS-AY-2021-Contract-Provider-10017562-5_2";
            FundingAllocation fundingAllocation = CreateFundingAllocation(fundingId);
            const string providerFundingId = "NMSS-AS-2021-10014016-1_0";
            const string fundingLineCode = "NMSS-001";
            fundingAllocation.AddProvider(providerFundingId)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (1, 10) });

            FundingAllocation fundingAllocation2 = CreateFundingAllocation(fundingId2);
            const string providerFundingIdWithoutPlannedValue = "NMSS-AS-2021-10014017-1_0";
            fundingAllocation2.AddProvider(providerFundingId)
                .AddFundingAllocationLine(fundingLineCode)
                .AddPeriods(new List<(int period, decimal plannedVale)> { (1, 10) });
            fundingAllocation2.AddProvider(providerFundingIdWithoutPlannedValue)
                .AddFundingAllocationLine(fundingLineCode);

            // act
            var isEquivalent = fundingAllocation.IsMateriallyEquivalentTo(fundingAllocation2);

            // assert
            isEquivalent.Should().BeTrue();
        }

        private static FundingAllocation CreateFundingAllocation(string fundingId = null)
        {
            var fundingIdToUse = fundingId ?? string.Empty;
            return new FundingAllocation(fundingIdToUse, string.Empty, string.Empty, string.Empty, string.Empty, 0, 0, 0, 1, 0);
        }
    }
}
