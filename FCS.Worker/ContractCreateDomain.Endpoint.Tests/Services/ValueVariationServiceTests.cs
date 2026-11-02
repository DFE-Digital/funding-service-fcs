namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.Services;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ValueVariationServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ValueVariationService_ShouldUpdateValueVariationWithCurrentMinusExistingApprovedValue()
        {
            // arrange
            const string approvedContractNumber = "some number";
            const string allocationNumber1 = "existing approved allocation1";
            const string allocationNumber2 = "existing approved allocation2";
            const decimal newAllocationValue = 1002m;
            Mock<ILookupManager> lookupManagerMock = new Mock<ILookupManager>();

            lookupManagerMock.Setup(r => r.GetAllocationsForApprovedContract(approvedContractNumber)).Returns(
                new List<AllocationValueData>
                {
                    new AllocationValueData
                    {
                        ContractAllocationNumber = allocationNumber1,
                        MaximumContractValue = 400
                    },
                    new AllocationValueData
                    {
                        ContractAllocationNumber = allocationNumber2,
                        MaximumContractValue = 600
                    },
                });

            ValueVariationService valueVariationService = new ValueVariationService(lookupManagerMock.Object);
            ExtendedContractType extendedContractType = new ExtendedContractType
            {
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        contractNumber = approvedContractNumber,
                        contractAllocations = new List<ExtendedContractAllocation>
                        {
                            new ExtendedContractAllocation
                            {
                                contractAllocationNumber = allocationNumber1,
                                maximumContractValue = newAllocationValue/2
                            },
                            new ExtendedContractAllocation
                            {
                                contractAllocationNumber = allocationNumber2,
                                maximumContractValue = newAllocationValue/2
                            }
                        },
                        contractValue = newAllocationValue
                    }
                }
            };

            // act
            valueVariationService.UpdateValueVariation(extendedContractType);

            // assert
            var childContract = extendedContractType.contracts.Single();
            childContract.ValueVariation.Should().Be(2);
            var allocation1 = childContract.contractAllocations.Single(a => a.contractAllocationNumber == allocationNumber1);
            var allocation2 = childContract.contractAllocations.Single(a => a.contractAllocationNumber == allocationNumber2);
            allocation1.ValueVariation.Should().Be(101m);
            allocation2.ValueVariation.Should().Be(-99m);
        }
    }
}
