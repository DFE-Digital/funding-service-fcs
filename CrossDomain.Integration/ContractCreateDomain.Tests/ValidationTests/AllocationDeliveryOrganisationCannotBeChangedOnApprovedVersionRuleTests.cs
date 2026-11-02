namespace ContractCreateDomain.Tests.ValidationTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRuleTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWithMultipleChildContracts()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-234", "DELORG2")
                }),
                new ContractIdentityInfo("CONTRACT-2", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-345", "DELORG3"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG4")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-234",
                                    DeliveryOrganisation = "DELORG2"
                                }
                            }
                        },
                        new contractType
                        {
                            contractNumber = "CONTRACT-2",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-345",
                                    DeliveryOrganisation = "DELORG3"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG4"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract).ToList();

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWithMultipleExistingChildContractsAndNewContract()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-234", "DELORG2")
                }),
                new ContractIdentityInfo("CONTRACT-2", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-345", "DELORG3"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG4")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-234",
                                    DeliveryOrganisation = "DELORG2"
                                }
                            }
                        },
                        new contractType
                        {
                            contractNumber = "CONTRACT-2",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-345",
                                    DeliveryOrganisation = "DELORG3"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG4"
                                }
                            }
                        },
                        new contractType
                        {
                            contractNumber = "CONTRACT-3",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-567",
                                    DeliveryOrganisation = "DELORG4"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-678",
                                    DeliveryOrganisation = "DELORG5"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract).ToList();

            // assert
            Assert.AreEqual(0, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldIdentifyVariousFailureScenariosWithinMultipleChildContracts()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-234", "DELORG2")
                }),
                new ContractIdentityInfo("CONTRACT-2", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-345", "DELORG3"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG4")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1",
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-234",
                                    DeliveryOrganisation = "DELORG22", // delivery org changed on approved allocation
                                    correlationId = "CORRID2"
                                }
                            }
                        },
                        new contractType
                        {
                            contractNumber = "CONTRACT-2",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-345",
                                    DeliveryOrganisation = "DELORG3",
                                    correlationId = "CORRID3"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = string.Empty, // delivery org removed on approved allocation
                                    correlationId = "CORRID4"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract).ToList();

            // assert
            Assert.AreEqual(2, failures.Count());
            Assert.IsTrue(failures.Contains("CORRID2"));
            Assert.IsTrue(failures.Contains("CORRID4"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenDeliveryOrganisationNotChanged()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG2")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldFailWhenDeliveryOrganisationChangedOnApprovedAllocation()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG2")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1",
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG3",
                                    correlationId = "CORRID2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.IsTrue(failures.Contains("CORRID2"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldFailWhenDeliveryOrganisationRemovedOnApprovedAllocation()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG2")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1",
                                    correlationId = "CORRID1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = string.Empty,
                                    correlationId = "CORRID2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.AreEqual(1, failures.Count());
            Assert.IsTrue(failures.Contains("CORRID2"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenDeliveryOrganisationSetOnNewAllocation()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-456", "DELORG2")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG2"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-789",
                                    DeliveryOrganisation = "DELORG3"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ErrorMessage_ShouldBeCorrect()
        {
            // arrange
            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(null);

            // act
            string errorMessage = rule.ErrorMessage;

            // assert
            Assert.AreEqual("Delivery Organisation cannot be changed or removed on an approved contract allocation", errorMessage);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ErrorLevel_ShouldBeCorrect()
        {
            // arrange
            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(null);

            // act
            errorInfoTypeLevel errorLevel = rule.ErrorLevel;

            // assert
            Assert.AreEqual(errorInfoTypeLevel.Allocation, errorLevel);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenDeliveryOrganisationWasPreviouslyBlank()
        {
            var contractIdentityInfos = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "DELORG1"),
                    new AllocationIdentityInfo("ALLOC-456", string.Empty)
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(contractIdentityInfos);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenConstructedWithEmptyContractIdentityInfoInstance()
        {
            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "DELORG1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "DELORG2"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(new List<ContractIdentityInfo>());

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenAddingDeliveryOrgsThatAreTheContractingOrg()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", string.Empty),
                    new AllocationIdentityInfo("ALLOC-456", string.Empty)
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "12345678"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "12345678"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldFailWhenAddingADeliveryOrgThatIsNotTheContractingOrg()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", string.Empty),
                    new AllocationIdentityInfo("ALLOC-456", string.Empty)
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "87654321"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "12345678"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldFaileWhenAddingDeliveryOrgsThatAreAllNotTheContractingOrg()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", string.Empty),
                    new AllocationIdentityInfo("ALLOC-456", string.Empty)
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "87654321"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "87654321"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenNoChangeToDeliveryOrgs()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", "87654321"),
                    new AllocationIdentityInfo("ALLOC-456", "87654321")
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "87654321"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "87654321"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenNoDeliveryOrgsExist()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", string.Empty),
                    new AllocationIdentityInfo("ALLOC-456", string.Empty)
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = string.Empty
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = string.Empty
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule_ShouldPassWhenAddingAllocationWithDifferentDeliveryOrg()
        {
            var immutableContractData = new[]
            {
                new ContractIdentityInfo("CONTRACT-1", new List<AllocationIdentityInfo>
                {
                    new AllocationIdentityInfo("ALLOC-123", string.Empty),
                })
            };

            var mashedMasterContract = new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new contractor
                    {
                        ukprn = 12345678
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = "CONTRACT-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-123",
                                    DeliveryOrganisation = "12345678"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "ALLOC-456",
                                    DeliveryOrganisation = "87654321"
                                }
                            }
                        }
                    }
                }
            };

            var rule = new AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(immutableContractData);

            // act
            IEnumerable<string> failures = rule.GetFailuresForItem(mashedMasterContract);

            // assert
            Assert.IsFalse(failures.Any());
        }
    }
}
