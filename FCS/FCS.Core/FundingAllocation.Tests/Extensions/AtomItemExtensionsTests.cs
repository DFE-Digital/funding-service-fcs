namespace FundingAllocation.Tests.Extensions
{
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class AtomItemExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomItem_ToFundingAllocation_ShouldTransformAtomItemToFundingAllocation()
        {
            // arrange
            var atomItem = new AtomItem
            {
                FundingId = "PSG-AY-1920-Information-LocalAuthority-201-1_0",
                FundingVersion = "1_0",
                Period = "1920",
                AllocationFundingStream = "PSG",
                Ukprn = "12345678",
                Value = 100m,
                PageNumber = 20,
                PositionInPage = 5,
                ProviderFundingIds = new[]
                {
                    "PSG-AY-2021-10083619-1_0",
                    "PSG-AY-2021-10078956-1_0",
                    "PSG-AY-2021-10086957-1_0"
                }
            };

            // act
            FundingAllocation fundingAllocation = atomItem.ToFundingAllocation(1);

            // assert
            fundingAllocation.Should().NotBeNull("an instance should be returned");
            fundingAllocation.Should().BeEquivalentTo(atomItem, options => options.ExcludingMissingMembers(), "all properties should be transformed");
            fundingAllocation.UKPRN.Should().Be(atomItem.Ukprn, "all properties should be transformed");
            fundingAllocation.ProviderFundingCount.Should().Be(atomItem.ProviderFundingIds.Length, "ProviderFundingCount should be the count of AtomItem.ProviderFundingIds");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomItem_ToDto_ShouldTransformAtomItemToFundingAllocationDto()
        {
            // arrange
            var atomItem = new AtomItem
            {
                FundingId = "PSG-AY-1920-Information-LocalAuthority-201-1_0",
                FundingVersion = "1_0",
                Period = "1920",
                AllocationFundingStream = "PSG",
                Ukprn = "12345678",
                Value = 100m,
                PageNumber = 20,
                PositionInPage = 5,
                ProviderFundingIds = new[]
                {
                    "PSG-AY-2021-10083619-1_0",
                    "PSG-AY-2021-10078956-1_0",
                    "PSG-AY-2021-10086957-1_0"
                }
            };

            // act
            FundingAllocationDto fundingAllocationDto = atomItem.ToFundingAllocationDto();

            // assert
            fundingAllocationDto.Should().NotBeNull("an instance should be returned");
            fundingAllocationDto.Should().BeEquivalentTo(atomItem, options => options.ExcludingMissingMembers(), "all properties should be transformed");
            fundingAllocationDto.UKPRN.Should().Be(atomItem.Ukprn, "all properties should be transformed");
        }
    }
}
