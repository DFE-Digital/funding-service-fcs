namespace ContractCreateDomain.Endpoint.Tests.UpdateContract
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class ContractTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void
            ContractType_AlignDeliveryOrgs_WhenAnyAllocationsHaveDeliveryOrgThatIsNotContractingOrg_ThenAllAllocationsShouldHaveDeliveryOrg()
        {
            const int contractingOrg = 11111111;
            const int deliveryOrg = 22222222;

            // arrange
            var allocationForContractingOrg1 = new contractAllocationsContractAllocation();
            var allocationForContractingOrg2 = new contractAllocationsContractAllocation();
            var allocationWithDeliveryOrg1 = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = deliveryOrg.ToString()
            };
            var allocationWithDeliveryOrg2 = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = deliveryOrg.ToString()
            };

            var contract = new contractType
            {
                contractor = new Contractor
                {
                    ukprn = contractingOrg
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    allocationForContractingOrg1,
                    allocationForContractingOrg2,
                    allocationWithDeliveryOrg1,
                    allocationWithDeliveryOrg2
                }
            };

            // act
            contract.AlignDeliveryOrgs();

            // assert
            allocationForContractingOrg1.DeliveryOrganisation.Should().Be(contractingOrg.ToString());
            allocationForContractingOrg2.DeliveryOrganisation.Should().Be(contractingOrg.ToString());
            allocationWithDeliveryOrg1.DeliveryOrganisation.Should().Be(deliveryOrg.ToString());
            allocationWithDeliveryOrg2.DeliveryOrganisation.Should().Be(deliveryOrg.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ContractType_AlignDeliveryOrgs_WhenAllAllocationsAreForTheContractingOrg_ThenNoAllocationsShouldHaveDeliveryOrg()
        {
            const int contractingOrg = 11111111;

            // arrange
            var allocationForContractingOrg1 = new contractAllocationsContractAllocation();
            var allocationForContractingOrg2 = new contractAllocationsContractAllocation();
            var allocationWithDeliveryOrgThatIsTheContractingOrg1 = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = contractingOrg.ToString()
            };
            var allocationWithDeliveryOrgThatIsTheContractingOrg2 = new contractAllocationsContractAllocation
            {
                DeliveryOrganisation = contractingOrg.ToString()
            };

            var contract = new contractType
            {
                contractor = new Contractor
                {
                    ukprn = contractingOrg,
                    legalName = $"{contractingOrg} Corp"
                },
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    allocationForContractingOrg1,
                    allocationForContractingOrg2,
                    allocationWithDeliveryOrgThatIsTheContractingOrg1,
                    allocationWithDeliveryOrgThatIsTheContractingOrg2
                }
            };

            // act
            contract.AlignDeliveryOrgs();

            // assert
            allocationForContractingOrg1.DeliveryOrganisation.Should().BeNull();
            allocationForContractingOrg2.DeliveryOrganisation.Should().BeNull();
            allocationWithDeliveryOrgThatIsTheContractingOrg1.DeliveryOrganisation.Should().BeNull();
            allocationWithDeliveryOrgThatIsTheContractingOrg2.DeliveryOrganisation.Should().BeNull();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_MergeAllocationsOnToContract_ShouldAddAllocationsThatAreNotPresent()
        {
            const string allocationNumber = "some existing number";
            const string newAllocationNumber = "new existing number";
            // arrange
            var contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber
                    }
                }
            };

            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = newAllocationNumber
                }
            };

            // act
            contract.MergeAllocationsOnToContract(allocations, ContractIntent.UpdateDraft);

            // assert
            contract.contractAllocations.Count.Should().Be(2);
            contract.contractAllocations.Select(ca => ca.contractAllocationNumber).Should()
                .Contain(newAllocationNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_MergeAllocationsOnToContract_ShouldAddDeliverablesToExistingAllocations()
        {
            const string allocationNumber = "some existing number";
            const int existingDeliverable = 1;
            const int newDeliverable = 2;
            // arrange
            var contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable
                                }
                            }
                        }
                    }
                }
            };

            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = allocationNumber,
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = newDeliverable
                            }
                        }
                    }
                }
            };

            // act
            contract.MergeAllocationsOnToContract(allocations, ContractIntent.UpdateDraft);

            // assert
            contract.contractAllocations.Count.Should().Be(1);
            var deliverables = contract.contractAllocations.Single().contractDeliverables
                .Select(d => d.deliverable.deliverableCode).ToList();
            deliverables.Count.Should().Be(2);
            deliverables.Should().Contain(newDeliverable);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_MergeAllocationsOnToContract_ShouldUpdateDeliverablePeriods_WhenUpdateDraftAmendment()
        {
            const string allocationNumber = "some existing number";
            const int existingDeliverable1 = 1;
            const int existingDeliverable2 = 2;
            const int augNewPlannedValue = 101;
            const int sepNewPlannedValue = 102;
            const int janNewPlannedValue = 103;
            const int octExistingPlannedValue = 104;
            // arrange
            var existingContract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable1
                                },
                                contractDeliverablePeriods =
                                    new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                    {
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 08,
                                            periodName = "Aug-20",
                                            plannedValue = 1
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 09,
                                            periodName = "Sep-20",
                                            plannedValue = 1
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 10,
                                            periodName = "Oct-20",
                                            plannedValue = octExistingPlannedValue
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2022,
                                            period = 01,
                                            periodName = "Jan-22",
                                            plannedValue = 1
                                        }
                                    }
                            },
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable2
                                }
                            }
                        }
                    }
                }
            };

            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = allocationNumber,
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = existingDeliverable1
                            },
                            contractDeliverablePeriods =
                                new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2021,
                                        period = 08,
                                        periodName = "Aug-20",
                                        plannedValue = augNewPlannedValue
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2021,
                                        period = 09,
                                        periodName = "Sep-20",
                                        plannedValue = sepNewPlannedValue
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2022,
                                        period = 01,
                                        periodName = "Jan-22",
                                        plannedValue = janNewPlannedValue
                                    }
                                }
                        }
                    }
                }
            };

            // act
            existingContract.MergeAllocationsOnToContract(allocations, ContractIntent.UpdateDraftAmendment);

            // assert
            existingContract.contractAllocations.Count.Should().Be(1);
            var deliverables = existingContract.contractAllocations.Single().contractDeliverables
                .Select(d => d.deliverable.deliverableCode).ToList();
            deliverables.Count.Should().Be(2);
            var existingDeliverable = existingContract.contractAllocations.Single().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == existingDeliverable1);
            var augPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2021 && dp.period == 8);
            augPeriod.plannedValue.Should().Be(augNewPlannedValue);
            var sepPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2021 && dp.period == 9);
            sepPeriod.plannedValue.Should().Be(sepNewPlannedValue);
            var octPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2021 && dp.period == 10);
            octPeriod.plannedValue.Should().Be(octExistingPlannedValue);
            var janPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2022 && dp.period == 1);
            janPeriod.plannedValue.Should().Be(janNewPlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_MergeAllocationsOnToContract_ShouldAddNewDeliverables_WhenUpdateDraftAmendment()
        {
            const string allocationNumber = "some existing number";
            const int existingDeliverable1 = 1;
            const int existingDeliverable2 = 2;
            const int newDeliverable3 = 3;
            const int augNewPlannedValue = 101;
            const int sepNewPlannedValue = 102;
            const int janNewPlannedValue = 103;
            // arrange
            var existingContract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable1
                                },
                                contractDeliverablePeriods =
                                    new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                    {
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 08,
                                            periodName = "Aug-20",
                                            plannedValue = 1
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 09,
                                            periodName = "Sep-20",
                                            plannedValue = 1
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2021,
                                            period = 10,
                                            periodName = "Oct-20",
                                            plannedValue = 1
                                        },
                                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                        {
                                            year = 2022,
                                            period = 01,
                                            periodName = "Jan-22",
                                            plannedValue = 1
                                        }
                                    }
                            },
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable2
                                }
                            }
                        }
                    }
                }
            };

            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = allocationNumber,
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = newDeliverable3
                            },
                            contractDeliverablePeriods =
                                new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2021,
                                        period = 08,
                                        periodName = "Aug-20",
                                        plannedValue = augNewPlannedValue
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2021,
                                        period = 09,
                                        periodName = "Sep-20",
                                        plannedValue = sepNewPlannedValue
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        year = 2022,
                                        period = 01,
                                        periodName = "Jan-22",
                                        plannedValue = janNewPlannedValue
                                    }
                                }
                        }
                    }
                }
            };

            // act
            existingContract.MergeAllocationsOnToContract(allocations, ContractIntent.UpdateDraftAmendment);

            // assert
            existingContract.contractAllocations.Count.Should().Be(1);
            var deliverables = existingContract.contractAllocations.Single().contractDeliverables
                .Select(d => d.deliverable.deliverableCode).ToList();
            deliverables.Count.Should().Be(3);
            var existingDeliverable = existingContract.contractAllocations.Single().contractDeliverables
                .Single(d => d.deliverable.deliverableCode == newDeliverable3);
            var augPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2021 && dp.period == 8);
            augPeriod.plannedValue.Should().Be(augNewPlannedValue);
            var sepPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2021 && dp.period == 9);
            sepPeriod.plannedValue.Should().Be(sepNewPlannedValue);
            var janPeriod =
                existingDeliverable.contractDeliverablePeriods.Single(dp => dp.year == 2022 && dp.period == 1);
            janPeriod.plannedValue.Should().Be(janNewPlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ContractType_MergeAllocationsOnToContract_ShouldThrowExceptionIfDeliverablesAlreadyExist_WhenUpdateDraft()
        {
            const string allocationNumber = "some existing number";
            const int existingDeliverable = 1;
            const int newDeliverable = 1;
            // arrange
            var contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractAllocationNumber = allocationNumber,
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = existingDeliverable
                                }
                            }
                        }
                    }
                }
            };

            List<ExtendedContractAllocation> allocations = new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = allocationNumber,
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = newDeliverable
                            }
                        }
                    }
                }
            };
            bool hasExceptionBeenThrown = false;
            try
            {
                // act
                contract.MergeAllocationsOnToContract(allocations, ContractIntent.UpdateDraft);
            }
            catch (InvalidOperationException)
            {
                hasExceptionBeenThrown = true;
            }

            // assert
            hasExceptionBeenThrown.Should().Be(true);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_FlattenDeliverablesOnAllocations_ShouldRemoveAllChildDeliverablesFromDeliverables()
        {
            // arrange
            contractType contract = new contractType
            {
                contractAllocations = new List<contractAllocationsContractAllocation>
                {
                    new contractAllocationsContractAllocation
                    {
                        contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                        {
                            new contractDeliverablesTypeContractDeliverable
                            {
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        }
                                    },
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 3
                                        }
                                    },
                                },
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 1
                                }
                            }
                        }
                    }
                }
            };
            // act
            contract.FlattenDeliverablesOnAllocations();

            // assert
            var allocation = contract.contractAllocations.Single();
            allocation.contractDeliverables.Count.Should().Be(3);
            allocation.contractDeliverables.ForEach(d =>
            {
                d.contractDeliverables.Should().BeEmpty();
            });
        }

    }
}
