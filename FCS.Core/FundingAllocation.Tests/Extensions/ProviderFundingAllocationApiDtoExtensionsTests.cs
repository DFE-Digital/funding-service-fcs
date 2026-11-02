namespace FundingAllocation.Tests.Extensions
{
    using System.Linq;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ProviderFundingAllocationApiDtoExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ProviderFundingAllocationDtoApi_ToProviderFunding_ShouldTransformAllValues()
        {
            const string providerFundingId = "PSG-AY-2021-10000002-1_0";

            // arrange
            ProviderFundingAllocationApiDto dto = new ProviderFundingAllocationApiDto
            {
                ProviderFundingId = providerFundingId,
                DeliveryUkprn = 10000002,
                FundingAllocationLines = new []
                {
                    new FundingAllocationLineApiDto
                    {
                        FundingLineCode = "1619-001",
                        FundingAllocationProfilePeriods = new []
                        {
                            new FundingAllocationProfilePeriodApiDto
                            {
                                Month = "January",
                                Year = 2021,
                                PlannedValue = 100m
                            },
                            new FundingAllocationProfilePeriodApiDto
                            {
                                Month = "February",
                                Year = 2021,
                                PlannedValue = 200m
                            }
                        }
                    }
                }
            };

            // act
            ProviderFunding providerFunding = dto.ToProviderFunding();

            // assert
            providerFunding.Should().NotBeNull("a valid entity instance should be returned");
           
            providerFunding.ProviderFundingId.Should().Be(dto.ProviderFundingId, "ProviderFundingId should be transformed correctly");

            FundingAllocationLine fundingAllocationLine = providerFunding.FundingAllocationLines.Single();

            fundingAllocationLine.FundingAllocationProfilePeriods.Should().NotBeNull("FundingAllocationProfilePeriods should be set to a valid instance");
            fundingAllocationLine.FundingAllocationProfilePeriods.Count.Should().Be(dto.FundingAllocationLines.SelectMany(fal => fal.FundingAllocationProfilePeriods).ToArray().Length, "all FundingAllocationProfilePeriods should be transformed");
            
            FundingAllocationProfilePeriod transformedProfilePeriod = fundingAllocationLine.FundingAllocationProfilePeriods.First();
            transformedProfilePeriod.ProviderFundingId.Should().Be(providerFundingId, "FundingAllocationProfilePeriod.ProviderFundingId should be transformed correctly");
            transformedProfilePeriod.Period.Should().Be(202101, "FundingAllocationProfilePeriod.Period should be transformed correctly");
            transformedProfilePeriod.PlannedValue.Should().Be(100m, "FundingAllocationProfilePeriod.PlannedValue should be transformed correctly");
        }
    }
}
