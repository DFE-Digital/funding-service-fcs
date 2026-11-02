namespace FundingAllocation.Tests.Dto
{
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FundingAllocationLineApiDtoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationLineApiDto_IsValid_ShouldFilterOutInvalidAllocationLines()
        {
            // arrange
            var providerFundingAllocationApiDto = new ProviderFundingAllocationApiDto
            {
                FundingAllocationLines = new []
                {
                    new FundingAllocationLineApiDto
                    {
                        Type = "NotPayment",
                        Value = null
                    },
                    new FundingAllocationLineApiDto
                    {
                        Type = "Payment",
                        Value = null
                    },
                    new FundingAllocationLineApiDto
                    {
                        Type = "NotPayment",
                        Value = "999"
                    },
                    new FundingAllocationLineApiDto
                    {
                        Type = "Payment",
                        Value = "100"
                    },
                    new FundingAllocationLineApiDto
                    {
                        Type = "Payment",
                        Value = "200"
                    }
                }
            };

            // act
            providerFundingAllocationApiDto.FundingAllocationLines = providerFundingAllocationApiDto.FundingAllocationLines.Where(fal => fal.IsValid()).ToArray();

            // assert 
            providerFundingAllocationApiDto.FundingAllocationLines.Length.Should().Be(2);
            providerFundingAllocationApiDto.FundingAllocationLines[0].Value.Should().Be("100");
            providerFundingAllocationApiDto.FundingAllocationLines[1].Value.Should().Be("200");
        }
    }
}