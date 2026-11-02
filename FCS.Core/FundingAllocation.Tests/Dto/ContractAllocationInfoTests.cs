namespace FundingAllocation.Tests.Dto
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractAllocationInfoTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationInfo_ShouldGetDeliveryUkrpnIfDifferentToContracting()
        {
            // arrange
            var inputDataAndResult = new List<(int contractingUkprn, int deliveryUkprn, int numAllocationsOnContract, string resultUkprn)>
            {
                (12345678, 12345678, 1, string.Empty),
                (12345678, 87654321, 1, "87654321"),
                (12345678, 12345678, 2, "12345678"),
            };

            inputDataAndResult.ForEach(input =>
            {
                ContractAllocationInfo contractAllocationInfo = new ContractAllocationInfo(
                    "fspCode",
                    "fsCode",
                    "allocRefPrefix",
                    input.deliveryUkprn, Enumerable.Empty<ContractDeliverableInfo>().ToList(),
                    numAllocationsOnContract:input.numAllocationsOnContract);

                    // act
                    var deliveryUkrpn = contractAllocationInfo.GetDeliveryUkprnIfDifferentToContracting(input.contractingUkprn);
                    
                    // assert
                    deliveryUkrpn.Should().Be(input.resultUkprn);
            });
        }
    }
}
