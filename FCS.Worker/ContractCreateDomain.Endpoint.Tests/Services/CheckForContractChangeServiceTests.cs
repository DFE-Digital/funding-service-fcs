namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.Services;
    using Endpoint.Services.DTOs;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using Optional;
    using Castle.Components.DictionaryAdapter;
    using FluentAssertions;
    using CorporateContract = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class CheckForContractChangeServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void
            CheckForContractChangeServiceTests_UpdateAllocationsThatHaveBeenAddedOrChangedService_ShouldSetHasBeenAddedOrUpdatedForForOneAllocationAcrossANumberOfContracts()
        {
            // arrange
            Option<CrmContract> crmContractX = new CrmContract(number: "Same_X", allocations: new List<CrmAllocation>
            {
                new CrmAllocation("X", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 10, 2019)
                    })
                })
            }).SomeWhen(c => c != null);

            Option<CrmContract> crmContractY = new CrmContract(number: "NotSame_Y", allocations: new List<CrmAllocation>
            {
                new CrmAllocation("Y", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 10, 2019)
                    })
                })
            }).SomeWhen(c => c != null);

            Option<CrmContract> crmContractZ = new CrmContract(number: "Same_Z", allocations: new List<CrmAllocation>
            {
                new CrmAllocation("Z", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 10, 2019)
                    })
                })
            }).SomeWhen(c => c != null);

            var importContractRequestType = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "Same_X",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation {contractAllocationNumber = "X", HasBeenUpdated = true}
                            }
                        },
                        new contractType
                        {
                            contractNumber = "NotSame_Y",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "Y", HasBeenUpdated = false,
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            deliverable = new deliverableType {deliverableCode = 1},
                                            contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                                            {
                                                new contractDeliverablePeriodType
                                                    {periodName = "201901", period = 1, plannedValue = 1}
                                            }
                                        },
                                    }
                                }
                            }
                        },
                        new contractType
                        {
                            contractNumber = "Same_Z",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation {contractAllocationNumber = "Z", HasBeenUpdated = true}
                            }
                        }
                    }
                }
            };

            var crmContractQueryRepositoryMock = new Mock<ICrmContractQueryRepository>();
            crmContractQueryRepositoryMock.Setup(m => m.GetApprovedContract("Same_X")).Returns(crmContractX);
            crmContractQueryRepositoryMock.Setup(m => m.GetApprovedContract("NotSame_Y")).Returns(crmContractY);
            crmContractQueryRepositoryMock.Setup(m => m.GetApprovedContract("Same_Z")).Returns(crmContractZ);

            var checkForAllocationChangeService = new CheckForAllocationChangeService();

            var checkForContractChangeService = new CheckForContractChangeService(checkForAllocationChangeService,
                crmContractQueryRepositoryMock.Object);

            // act 
            checkForContractChangeService.UpdateAllocationsThatHaveBeenAddedOrChangedService(importContractRequestType
                .contract);

            // assert
            var assertContractX =
                importContractRequestType.contract.contracts.Single(c => c.contractNumber == "Same_X");
            Assert.IsFalse(assertContractX.contractAllocations.Single().HasBeenAddedOrUpdated,
                "HasBeenAddedOrUpdated incorrectly set in Contract Same_X's allocation");

            var assertContractY =
                importContractRequestType.contract.contracts.Single(c => c.contractNumber == "NotSame_Y");
            Assert.IsTrue(assertContractY.contractAllocations.Single().HasBeenAddedOrUpdated,
                "HasBeenAddedOrUpdated incorrectly set in Contract NotSame_Y's allocation");

            var assertContractZ =
                importContractRequestType.contract.contracts.Single(c => c.contractNumber == "Same_Z");
            Assert.IsFalse(assertContractZ.contractAllocations.Single().HasBeenAddedOrUpdated,
                "HasBeenAddedOrUpdated incorrectly set in Contract Same_Z's allocation");
        }

        [TestMethod, TestCategory("UnitTest")]
        [ExpectedException(typeof(ArgumentException))]
        public void
            CheckForContractChangeServiceTests_UpdateAllocationsThatHaveBeenAddedOrChangedService_ShouldThrowArgumentExceptionWhenNoCrmContractIsRetrieved()
        {
            // arrange 
            var importContractRequestType = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "X",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation {contractAllocationNumber = "X"}
                            }
                        }
                    }
                }
            };

            var crmContractQueryRepositoryMock = new Mock<ICrmContractQueryRepository>();
            crmContractQueryRepositoryMock.Setup(m => m.GetApprovedContract("X")).Returns(null);

            var checkForAllocationChangeService = new CheckForAllocationChangeService();

            var checkForContractChangeService = new CheckForContractChangeService(checkForAllocationChangeService,
                crmContractQueryRepositoryMock.Object);

            // act & assert
            checkForContractChangeService.UpdateAllocationsThatHaveBeenAddedOrChangedService(importContractRequestType
                .contract);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForContractChangeServiceTests_UpdateCorpContractAllocations_ShouldPopulateHasBeenAddedOrUpdated()
        {
            // arrange
            const string allocationNumber1 = "some 1";
            const string allocationNumber2 = "some 2";
            const string allocationNumber3 = "some 3";
            CheckForContractChangeService service = new CheckForContractChangeService(null, null);
            CorporateContract.contractType corpContract = new CorporateContract.contractType
            {
                contractAllocations = new List<CorporateContract.contractAllocationsContractAllocation>
                {
                    new CorporateContract.contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber1
                    },
                    new CorporateContract.contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber2
                    },
                    new CorporateContract.contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber3
                    },
                }
            };

            contractType contractRequest = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = allocationNumber1,
                        HasBeenUpdated = true,
                    },
                    new contractAllocation
                    {
                        contractAllocationNumber = allocationNumber2,
                        HasBeenAdded = true
                    },
                    new contractAllocation
                    {
                        contractAllocationNumber = allocationNumber3
                    }
                }
            };

            // act
            service.UpdateCorpContractAllocations(corpContract, contractRequest);
            // assert
            corpContract.contractAllocations.Single(ca => ca.contractAllocationNumber == allocationNumber1)
                .HasBeenAddedOrUpdated.Should().Be(true, $"allocation {allocationNumber1} has a problem");
            corpContract.contractAllocations.Single(ca => ca.contractAllocationNumber == allocationNumber2)
                .HasBeenAddedOrUpdated.Should().Be(true, $"allocation {allocationNumber2} has a problem");
            corpContract.contractAllocations.Single(ca => ca.contractAllocationNumber == allocationNumber2)
                .HasBeenAdded.Should().Be(true, $"allocation {allocationNumber2} has a problem with HasBeenAdded property");
            corpContract.contractAllocations.Single(ca => ca.contractAllocationNumber == allocationNumber3)
                .HasBeenAddedOrUpdated.Should().Be(false, $"allocation {allocationNumber3} has a problem");
        }
    }
}