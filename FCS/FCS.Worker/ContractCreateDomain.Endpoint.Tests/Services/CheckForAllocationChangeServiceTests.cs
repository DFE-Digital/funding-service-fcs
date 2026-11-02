namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.Services;
    using Endpoint.Services.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class CheckForAllocationChangeServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CheckForAllocationChangeService_ShouldUpdateImportAllocationHasBeenAdded_WhenAllocationIsNotPresent()
        {
            // arrange
            CrmContract crmContract = new CrmContract("", new List<CrmAllocation>
            {
                new CrmAllocation("X", null, null, null)
            });
            
            contractType importContract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = "Y"
                    }
                }
            };

            // act
            new CheckForAllocationChangeService().UpdateAllocationsThatHaveChangedOrBeenAdded(crmContract, importContract);

            // assert
            Assert.IsTrue(importContract.contractAllocations.First().HasBeenAdded);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForAllocationChangeService_ShouldUpdateImportAllocationHasBeenAdded_WhenAllocationIsPresent()
        {
            // arrange
            CrmContract crmContract = new CrmContract("", new List<CrmAllocation>
            {
                new CrmAllocation("X", null, null, null)
            });

            contractType importContract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = "X"
                    }
                }
            };

            // act
            new CheckForAllocationChangeService().UpdateAllocationsThatHaveChangedOrBeenAdded(crmContract, importContract);

            // assert
            Assert.IsFalse(importContract.contractAllocations.First().HasBeenAdded);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForAllocationChangeService_ShouldUpdateImportContractAllocation_WhenMatchingImportHasADifferentPlannedValue()
        {
            // arrange

            CrmContract crmContract = new CrmContract("", new List<CrmAllocation>
            {
                new CrmAllocation("Y", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 9, 2019)
                    })
                })
            });

            contractType importContract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = "Y",
                        contractDeliverables = new List<contractDeliverable>
                        {
                            new contractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                {
                                    new contractDeliverablePeriodType
                                    {
                                        period = 1,
                                        periodName = "201901",
                                        plannedValue = 10
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // act
            new CheckForAllocationChangeService().UpdateAllocationsThatHaveChangedOrBeenAdded(crmContract, importContract);

            // assert
            Assert.IsTrue(importContract.contractAllocations.First().HasBeenAddedOrUpdated);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForAllocationChangeService_ShouldUpdateImportedAllocation_WhenMatchingImportHasADifferentDeliverableCode()
        {
            // arrange
            CrmContract crmContract = new CrmContract("", new List<CrmAllocation>
            {
                new CrmAllocation("Y", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 10, 2019)
                    })
                })
            });

            contractType importContract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = "Y",
                        contractDeliverables = new List<contractDeliverable>
                        {
                            new contractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 2
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                {
                                    new contractDeliverablePeriodType
                                    {
                                        plannedValue = 10
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // act
            new CheckForAllocationChangeService().UpdateAllocationsThatHaveChangedOrBeenAdded(crmContract, importContract);

            // assert
            Assert.IsTrue(importContract.contractAllocations.First().HasBeenAddedOrUpdated);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CheckForAllocationChangeService_UpdateAllocationsThatHaveChangedOrBeenAdded_ShouldSetNewAllocationFromMergeToHasBeenAddedOrUpdated()
        {
            // arrange
            CrmContract crmContract = new CrmContract("", new List<CrmAllocation>
            {
                new CrmAllocation("X", null, null, new List<CrmDeliverable>
                {
                    new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                    {
                        new CrmDeliverablePeriod(1, "201901", 10, 2019)
                    })
                })
            });

            contractType mergedContract = new contractType
            {
                contractAllocations = new List<contractAllocation>
                {
                    new contractAllocation
                    {
                        contractAllocationNumber = "X",
                        contractDeliverables = new List<contractDeliverable>
                        {
                            new contractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                {
                                    new contractDeliverablePeriodType
                                    {
                                        plannedValue = 10,
                                        period = 1,
                                        year = 2019
                                    }
                                }
                            }
                        }
                    },
                    new contractAllocation
                    {
                        contractAllocationNumber = "Y",
                        contractDeliverables = new List<contractDeliverable>
                        {
                            new contractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 2
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                {
                                    new contractDeliverablePeriodType
                                    {
                                        plannedValue = 10
                                    }
                                }
                            }
                        }
                    },
                    new contractAllocation
                    {
                        contractAllocationNumber = "Z",
                        contractDeliverables = new List<contractDeliverable>
                        {
                            new contractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 2
                                },
                                contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                {
                                    new contractDeliverablePeriodType
                                    {
                                        plannedValue = 10
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // act
            new CheckForAllocationChangeService().UpdateAllocationsThatHaveChangedOrBeenAdded(crmContract, mergedContract);

            // assert
            Assert.IsFalse(mergedContract.contractAllocations.First(ca => ca.contractAllocationNumber == "X").HasBeenAddedOrUpdated, "The allocation X has not been changed");
            Assert.IsTrue(mergedContract.contractAllocations.First(ca => ca.contractAllocationNumber == "Y").HasBeenAddedOrUpdated, "The allocation Y has not been changed");
            Assert.IsTrue(mergedContract.contractAllocations.First(ca => ca.contractAllocationNumber == "Z").HasBeenAddedOrUpdated, "The allocation Z has not been changed");
        }
    }
}
