namespace ContractCreateDomain.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class MasherTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_ContractLevelDetailsChanged_ReturnsMashedContractWithUpdatesContractDetails()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                        fundingTypeCode = "dont go changing"
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                startDate = new DateTime(2015, 9, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2016, 6, 30, 0, 0, 0, DateTimeKind.Utc),
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        startDate = new DateTime(2015, 9, 1, 0, 0, 0, DateTimeKind.Utc),
                        endDate = new DateTime(2016, 6, 30, 0, 0, 0, DateTimeKind.Utc),
                        fundingTypeCode = "dont go changing"
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                startDate = new DateTime(2015, 8, 1),
                endDate = new DateTime(2016, 7, 31),

                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        startDate = new DateTime(2015, 8, 1),
                        endDate = new DateTime(2016, 7, 31)
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.AreEqual(expectedMashedResult.contracts[0].startDate, actualMashedResult.contracts[0].startDate,
                "Contract details were not updated");
            Assert.AreEqual(expectedMashedResult.contracts[0].endDate, actualMashedResult.contracts[0].endDate,
                "Contract details were not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_ContractLevelDetailsChanged_ReturnsMashedContract_CrmNotPresentSet()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                startDate = DateTime.Today.AddDays(1),
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "22222",
                        startDate = DateTime.Today.AddDays(1),
                        fundingTypeCode = "dont go changing"
                    },
                    new contractType()
                    {
                        contractNumber = "11111",
                        startDate = DateTime.Today.AddDays(1),
                        fundingTypeCode = "dont go changing",
                        crmNotPresent = true
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                startDate = DateTime.Today,
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "22222",
                        startDate = DateTime.Today,
                        fundingTypeCode = "dont go changing"
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                CRMIntent = Intent.UpdateDraft,
                contractNumber = "123456",
                startDate = DateTime.Today.AddDays(1),
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "11111",
                        startDate = DateTime.Today.AddDays(1)
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            // Assert
            Assert.AreEqual(expectedMashedResult.crmNotPresent, actualMashedResult.crmNotPresent,
                "Contract details were not updated where delta contract not present in CRM.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_AllocationDetailsUpdated_ReturnsMashedContractWithUpdatedAllocation()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                UoPCode = "After updated allocation"
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                UoPCode = "Before updated allocation"
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                CRMIntent = Intent.UpdateDraft,
                                UoPCode = "After updated allocation"
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].description,
                actualMashedResult.contracts[0].contractAllocations[0].description,
                "Allocation details were not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_AllocationAdded_ReturnsMashedContractWithAddedAllocation()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            },
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                description = "AllocationToBeAdded"
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        CRMIntent = Intent.UpdateDraft,
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                CRMIntent = Intent.New,
                                description = "AllocationToBeAdded"
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(expectedMashedResult.contracts[0].contractAllocations.Count
                          == actualMashedResult.contracts[0].contractAllocations.Count);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[1].description,
                actualMashedResult.contracts[0].contractAllocations[1].description,
                "Allocation details were not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_AllocationDeleted_ReturnsMashedContractWithRemovedAllocation()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            },
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                description = "AllocationToBeDeleted"
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                CRMIntent = Intent.DeleteDraft,
                                description = "AllocationToBeDeleted"
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(expectedMashedResult.contracts[0].contractAllocations.Count ==
                          actualMashedResult.contracts[0].contractAllocations.Count,
                "Allocation details were not deleted");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_AllocationDeleted_WithDeleteDraftAmendmentSyntax_ReturnsMashedContractWithRemovedAllocation()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                amendmentType = amendmentType.Notification,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                amendmentType = amendmentType.Notification,
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            },
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                description = "AllocationToBeDeleted"
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                amendmentType = amendmentType.Notification,
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraftAmendment,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                CRMIntent = Intent.DeleteDraftAmendment,
                                description = "AllocationToBeDeleted"
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(
                expectedMashedResult.contracts[0].contractAllocations.Count == actualMashedResult.contracts[0].contractAllocations.Count,
                "Allocation details were not deleted");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_AllocationUpdated_ReturnsMashedContractWithNewAllocation_CrmNotPresentSet()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            },
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                description = "Allocation to be updated",
                                crmNotPresent = true
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                description = "AllocationToRemain"
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "2",
                                CRMIntent = Intent.UpdateDraft,
                                description = "Allocation to be updated"
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[1].crmNotPresent,
                actualMashedResult.contracts[0].contractAllocations[1].crmNotPresent,
                "Allocation details were not updated for delta allocation which did not exist in CRM");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableUpdated_ReturnsMashedContractWithUpdatedDeliverable()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "After Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Before Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraft,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        CRMIntent = Intent.UpdateDraft,
                                        deliverableDescription = "After Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.AreEqual(
                expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].deliverableDescription,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].deliverableDescription,
                "Deliverable details were not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableAdded_ReturnsMashedContractWithAddedDeliverable()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    },
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "Added Deliverable"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraft,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        CRMIntent = Intent.New,
                                        deliverableDescription = "Added Deliverable"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count ==
                          expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count);
            Assert.AreEqual(
                expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].deliverableDescription,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].deliverableDescription,
                "Deliverable details were not added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableDeleted_ReturnsMashedContractWithDeletedDeliverable()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    },
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "Deliverable to be Deleted"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraft,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        CRMIntent = Intent.DeleteDraft,
                                        deliverableDescription = "Deliverable to be Deleted"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count ==
                          actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count,
                "Deliverable could not be deleted.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableDeleted_WithDeleteDraftAmendmentSyntax_ReturnsMashedContractWithDeletedDeliverable()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                amendmentType = amendmentType.Notification,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        amendmentType = amendmentType.Notification,
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Remaining Deliverable"
                                    },
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "Deliverable to be Deleted"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                amendmentType = amendmentType.Notification,
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        CRMIntent = Intent.UpdateDraftAmendment,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraftAmendment,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        CRMIntent = Intent.DeleteDraftAmendment,
                                        deliverableDescription = "Deliverable to be Deleted"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(
                expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count == actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count,
                "Deliverable could not be deleted.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableUpdated_ReturnsMashedContractWithNewDeliverable_CrmNotPresentSet()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Before Mash description"
                                    },
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "After Mash description",
                                        crmNotPresent = true
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Before Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraft,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        CRMIntent = Intent.UpdateDraft,
                                        deliverableDescription = "After Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count == 2,
                "New del with CrmNotPresent was not added.");
            Assert.AreEqual(
                expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].crmNotPresent,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].crmNotPresent,
                "Deliverable details were not updated with new deliverable and CRM not present set to true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverableUpdate_ReturnsMashedContractWithNewDeliverable_UnitCostSet()
        {
            // Arrange
           
            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Before Mash description"
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.Amendment,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.Amendment,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        CRMIntent = Intent.Amendment,
                                        deliverableDescription = "After Mash description",
                                        unitCost = 10
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            
            Assert.AreEqual(
               10,
               actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].unitCost,
               "Deliverable details were not updated with unitCost");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_DeliverablePeriodUpdated_ReturnsMashedContractWithUpdatedDeliverblePeriod()
        {
            // Arrange
            var expectedMashedResult = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                        {
                                            new contractDeliverablePeriodType()
                                            {
                                                period = 1,
                                                plannedValue = 500
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var crmContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType()
                    {
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                        {
                                            new contractDeliverablePeriodType()
                                            {
                                                period = 1,
                                                plannedValue = 100
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var spreadsheetContract = new contractType()
            {
                contractNumber = "123456",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                CRMIntent = Intent.UpdateDraft,
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        CRMIntent = Intent.UpdateDraft,
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                        {
                                            new contractDeliverablePeriodType()
                                            {
                                                period = 1,
                                                plannedValue = 500
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.AreEqual(
                expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0]
                    .contractDeliverablePeriods[0].plannedValue,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0]
                    .contractDeliverablePeriods[0].plannedValue,
                "Deliverable period details were not updated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_ShouldMapCrmIntent_OfImportVersionContract_AtEveryLevel()
        {
            // Arrange

            #region crmContract

            var crmContract = new contractType
            {
                contractNumber = "0",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "2",
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
                                                plannedValue = 100
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            #endregion

            #region importContract

            var importContract = new contractType
            {
                contractNumber = "0",
                CRMIntent = Intent.UpdateDraft,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = Intent.New,
                                contractAllocationNumber = "3",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        CRMIntent = Intent.New,
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                        {
                                            new contractDeliverablePeriodType
                                            {
                                                period = 1,
                                                plannedValue = 500
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            #endregion

            // Act

            var masher = new Masher();
            var result = masher.Mash(crmContract, importContract);

            Assert.IsTrue(result.contracts.First().CRMIntent == Intent.UpdateDraft);
            Assert.IsTrue(result.contracts.First().contractAllocations.First().CRMIntent == Intent.New);
            Assert.IsTrue(result.contracts.First().contractAllocations.First()
                            .contractDeliverables.First().CRMIntent == Intent.New);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_WhenCrmContractIsNull_ShouldCreateImportContractAsMashedContractWithCrmNotPresent()
        {
            // Arrange
            #region 'spreadsheetContract'
            var spreadsheetContract = new contractType()
            {
                CRMIntent = Intent.UpdateDraft,
                contractNumber = "123456",
                correlationId = "1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent=Intent.UpdateDraft,
                        contractNumber = "123456",
                        correlationId = "2",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                            {
                                contractAllocationNumber = "1",
                                CRMIntent = Intent.UpdateDraft,
                                correlationId = "3",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        correlationId = "4",
                                        CRMIntent = Intent.UpdateDraft
                                    },
                                    new contractDeliverable()
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        correlationId = "5",
                                        CRMIntent = Intent.UpdateDraft
                                    }
                                }
                            }
                        }
                    }
                }
            };
            #endregion

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(null, spreadsheetContract);

            // Assert
            Assert.IsTrue(actualMashedResult.crmNotPresent,
                "Master contract Crm not Present not set to true");
            Assert.AreEqual("123456", actualMashedResult.contractNumber);
            Assert.IsTrue(actualMashedResult.contracts[0].crmNotPresent,
                "Contract Crm not Present not set to true");
            Assert.IsTrue(actualMashedResult.contracts[0].contractAllocations[0].crmNotPresent,
                "Contract allocation Crm not Present not set to true");
            Assert.IsTrue(actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].crmNotPresent,
                "Deliverable Crm not Present not set to true");
            Assert.IsTrue(actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].crmNotPresent,
               "Deliverable Crm not Present not set to true");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_FullHappyPath_AllValuesUpdated()
        {
            // Arrange
            #region 'Expected result'

            var tenderAwardReference = Guid.NewGuid().ToString();
            var lepName = Guid.NewGuid().ToString();
            var expectedMashedResult = new contractType
            {
                CRMIntent = Intent.UpdateDraft,
                contractNumber = "123456",
                contractor = new Contractor
                {
                    organisationIdentifier = "UPDATEORGID",
                    Upin = "UPDATEUPIN",
                    organisationStatus = "UPDATESTATUS"
                },
                correlationId = "1",
                startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractor = new Contractor
                        {
                            organisationIdentifier = "UPDATEORGID",
                            Upin = "UPDATEUPIN",
                            organisationStatus = "UPDATESTATUS"
                        },
                        startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                        description = "Updated contract description",
                        correlationId = "2",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                CRMIntent = Intent.UpdateDraft,
                                correlationId = "3",
                                description = "Updated allocation description",
                                tenderSpecificationReference = "Updated ittReference",
                                tenderAwardReference = tenderAwardReference,
                                LEPName = lepName,
                                LEPCode = "Updated lepCode",
                                UoPCode = "Updated uopCode",
                                endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                                fundingStreamCode = "Updated fundingStreamCode",
                                investmentPriority = "Updated priority",
                                activityDescription = "Updated projectDescription",
                                startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                                period = new periodType { period = "1516" },
                                DeliveryOrganisation = "NEWDELIVERYORG",
                                HasBeenUpdated = true,
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
                                                correlationId = "0000",
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeName = "P1"
                                                },
                                                plannedValue = 111,
                                                plannedVolume = 222,
                                                unitCost = 333,
                                                aggregate = true
                                            }
                                        },
                                        deliverableDescription = "Updated Deliverable",
                                        correlationId = "4",
                                        CRMIntent = Intent.UpdateDraft
                                    },
                                    new contractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "Added Deliverable",
                                        correlationId = "5",
                                        CRMIntent = Intent.New
                                    }
                                }
                            }
                        }
                    }
                }
            };

            #endregion

            #region 'crmContract'

            var crmContract = new contractType
            {
                contractNumber = "123456",
                contractor = new Contractor
                {
                    organisationIdentifier = "ORIGINALORGID",
                    Upin = "ORIGINALUPIN",
                    organisationStatus = "ORIGINALSTATUS"
                },
                startDate = new DateTime(2015, 8, 2, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2016, 7, 30, 0, 0, 0, DateTimeKind.Utc),
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "123456",
                        contractor = new Contractor
                        {
                            organisationIdentifier = "ORIGINALORGID",
                            Upin = "ORIGINALUPIN",
                            organisationStatus = "ORIGINALSTATUS"
                        },
                        startDate = new DateTime(2015, 8, 2, 0, 0, 0, DateTimeKind.Utc),
                        endDate = new DateTime(2016, 7, 30, 0, 0, 0, DateTimeKind.Utc),
                        description = "Pre Update contract description",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                description = "pre Update allocation description",
                                tenderSpecificationReference = "pre Update ittReference",
                                LEPCode = "pre Update lepCode",
                                UoPCode = "pre Update uopCode",
                                endDate = new DateTime(2016, 7, 30, 0, 0, 0, DateTimeKind.Utc),
                                fundingStreamCode = "pre Update fundingStreamCode",
                                investmentPriority = "pre Update priority",
                                activityDescription = "pre Update projectDescription",
                                startDate = new DateTime(2015, 8, 2, 0, 0, 0, DateTimeKind.Utc),
                                period = new periodType { period = "1415" },
                                DeliveryOrganisation = "ORIGINALDELIVERYORG",
                                HasBeenUpdated = false,
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
                                                correlationId = "0000",
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeName = "P1"
                                                },
                                                plannedValue = 111,
                                                plannedVolume = 222,
                                                unitCost = 333,
                                                aggregate = true
                                            }
                                        },
                                        deliverableDescription = "pre Update Deliverable",
                                    }
                                }
                            }
                        }
                    }
                }
            };
            #endregion

            #region 'spreadsheetContract'

            var spreadsheetContract = new contractType
            {
                CRMIntent = Intent.UpdateDraft,
                contractNumber = "123456",
                contractor = new Contractor
                {
                    organisationIdentifier = "UPDATEORGID",
                    Upin = "UPDATEUPIN",
                    organisationStatus = "UPDATESTATUS"
                },
                correlationId = "1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "123456",
                        contractor = new Contractor
                        {
                            organisationIdentifier = "UPDATEORGID",
                            Upin = "UPDATEUPIN",
                            organisationStatus = "UPDATESTATUS"
                        },
                        startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc),
                        description = "Updated contract description",
                        correlationId = "2",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                CRMIntent = Intent.UpdateDraft,
                                correlationId = "3",
                                description = "Updated allocation description",
                                tenderSpecificationReference = "Updated ittReference",
                                tenderAwardReference =  tenderAwardReference,
                                LEPName = lepName,
                                LEPCode = "Updated lepCode",
                                UoPCode = "Updated uopCode",
                                endDate = new DateTime(2016, 7, 31, 0, 0, 0, DateTimeKind.Utc), // change from 30th
                                fundingStreamCode = "Updated fundingStreamCode",
                                investmentPriority = "Updated priority",
                                activityDescription = "Updated projectDescription",
                                startDate = new DateTime(2015, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                                period = new periodType { period = "1516" },
                                DeliveryOrganisation = "NEWDELIVERYORG",
                                HasBeenUpdated = true,
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 1
                                        },
                                        deliverableDescription = "Updated Deliverable",
                                        correlationId = "4",
                                        CRMIntent = Intent.UpdateDraft
                                    },
                                    new contractDeliverable
                                    {
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2
                                        },
                                        deliverableDescription = "Added Deliverable",
                                        correlationId = "5",
                                        CRMIntent = Intent.New
                                    }
                                }
                            }
                        }
                    }
                }
            };
            #endregion

            // Act
            var masher = new Masher();
            var actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // Assert
            Assert.IsTrue(actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count ==
                          expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables.Count);
            
            //Assert contract mashed
            Assert.AreEqual(expectedMashedResult.contracts[0].CRMIntent, actualMashedResult.contracts[0].CRMIntent);
            Assert.AreEqual(expectedMashedResult.contracts[0].correlationId, actualMashedResult.contracts[0].correlationId);
            Assert.AreEqual(expectedMashedResult.contracts[0].startDate, actualMashedResult.contracts[0].startDate);
            Assert.AreEqual(expectedMashedResult.contracts[0].endDate, actualMashedResult.contracts[0].endDate);
            Assert.AreEqual(expectedMashedResult.contracts[0].description, actualMashedResult.contracts[0].description);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractType1, actualMashedResult.contracts[0].contractType1);

            Assert.AreEqual(expectedMashedResult.contractor.organisationIdentifier, actualMashedResult.contractor.organisationIdentifier);
            Assert.AreEqual(expectedMashedResult.contractor.Upin, actualMashedResult.contractor.Upin);
            Assert.AreEqual(expectedMashedResult.contractor.organisationStatus, actualMashedResult.contractor.organisationStatus);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractor.organisationIdentifier, actualMashedResult.contracts[0].contractor.organisationIdentifier);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractor.Upin, actualMashedResult.contracts[0].contractor.Upin);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractor.organisationStatus, actualMashedResult.contracts[0].contractor.organisationStatus);

            //Assert allocations mashed
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].CRMIntent, actualMashedResult.contracts[0].contractAllocations[0].CRMIntent);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].correlationId, actualMashedResult.contracts[0].contractAllocations[0].correlationId);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].description, actualMashedResult.contracts[0].contractAllocations[0].description);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].tenderSpecificationReference, actualMashedResult.contracts[0].contractAllocations[0].tenderSpecificationReference);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].LEPCode, actualMashedResult.contracts[0].contractAllocations[0].LEPCode);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].UoPCode, actualMashedResult.contracts[0].contractAllocations[0].UoPCode);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].endDate, actualMashedResult.contracts[0].contractAllocations[0].endDate);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].fundingStreamCode, actualMashedResult.contracts[0].contractAllocations[0].fundingStreamCode);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].investmentPriority, actualMashedResult.contracts[0].contractAllocations[0].investmentPriority);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].activityDescription, actualMashedResult.contracts[0].contractAllocations[0].activityDescription);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].startDate, actualMashedResult.contracts[0].contractAllocations[0].startDate);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].period.period, actualMashedResult.contracts[0].contractAllocations[0].period.period);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].tenderAwardReference, actualMashedResult.contracts[0].contractAllocations[0].tenderAwardReference);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].LEPName, actualMashedResult.contracts[0].contractAllocations[0].LEPName);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].DeliveryOrganisation, actualMashedResult.contracts[0].contractAllocations[0].DeliveryOrganisation);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].HasBeenAddedOrUpdated, actualMashedResult.contracts[0].contractAllocations[0].HasBeenAddedOrUpdated, 
                "Allocation HasBeenAddedOrUpdated was not mashed correctly");

            //Assert deliverables mashed
            //Del 1
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].CRMIntent,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].CRMIntent);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].correlationId,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].correlationId);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].deliverableDescription,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].deliverableDescription);
            //Del 1 periods
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].correlationId,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].correlationId);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].periodType.periodTypeName,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].periodType.periodTypeName);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].plannedValue,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].plannedValue);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].plannedVolume,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].plannedVolume);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].unitCost,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].unitCost);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].aggregate,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[0].contractDeliverablePeriods[0].aggregate);

            //Del2
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].CRMIntent,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].CRMIntent);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].correlationId,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].correlationId);
            Assert.AreEqual(expectedMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].deliverableDescription,
                actualMashedResult.contracts[0].contractAllocations[0].contractDeliverables[1].deliverableDescription);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_MapsIsWithdrawnContractWithContractNUmberPresentInCrmFlag()
        {
            // Arrange
            var expectedMashedResult = new contractType
            {
                CRMIntent = Intent.Amendment,
                contractNumber = "SFA-1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.Amendment,
                        contractNumber = "MAIN-1",
                        contractor = new Contractor
                        {
                            organisationIdentifier = "ORG1"
                        },
                        IsWithdrawnContractWithContractNumberPresentInCrm = true
                    }
                }
            };

            var crmContract = new contractType
            {
                contractNumber = "SFA-1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "MAIN-1",
                        contractor = new Contractor
                        {
                            organisationIdentifier = "ORG1"
                        }
                    }
                }
            };            

            var importContract = new contractType
            {
                CRMIntent = Intent.Amendment,
                contractNumber = "SFA-1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.Amendment,
                        contractNumber = "MAIN-1",
                        IsWithdrawnContractWithContractNumberPresentInCrm = true
                    }
                }
            };

            // Act
            var masher = new Masher();
            var result = masher.Mash(crmContract, importContract);

            // Assert
            Assert.AreEqual(expectedMashedResult.contracts.Single().IsWithdrawnContractWithContractNumberPresentInCrm,
                result.contracts.Single().IsWithdrawnContractWithContractNumberPresentInCrm);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MashContracts_ShouldMashMultipleChildContracts()
        {
            // arrange
            contractType crmContract = new contractType
            {
                contractNumber = "MASTER-1",
                startDate = new DateTime(2015, 9, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2016, 6, 30, 0, 0, 0, DateTimeKind.Utc),
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "CHILD-1",
                        description = "ORIGINAL CHILD DESCRIPTION 1"
                    },
                    new contractType
                    {
                        contractNumber = "CHILD-2",
                        description = "ORIGINAL CHILD DESCRIPTION 2"
                    },
                    new contractType
                    {
                        contractNumber = "CHILD-3",
                        description = "ORIGINAL CHILD DESCRIPTION 3"
                    }
                }
            };

            contractType spreadsheetContract = new contractType
            {
                contractNumber = "MASTER-1",
                startDate = new DateTime(2015, 8, 1),
                endDate = new DateTime(2016, 7, 31),
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "CHILD-1",
                        description = "REVISED CHILD DESCRIPTION 1"
                    },
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "CHILD-2",
                        description = "REVISED CHILD DESCRIPTION 2"
                    },
                    new contractType
                    {
                        CRMIntent = Intent.UpdateDraft,
                        contractNumber = "CHILD-3",
                        description = "REVISED CHILD DESCRIPTION 3"
                    }
                }
            };

            // act
            Masher masher = new Masher();
            contractType actualMashedResult = masher.Mash(crmContract, spreadsheetContract);

            // assert
            Assert.AreEqual("REVISED CHILD DESCRIPTION 1", actualMashedResult.contracts.Single(c => c.contractNumber == "CHILD-1").description);
            Assert.AreEqual("REVISED CHILD DESCRIPTION 2", actualMashedResult.contracts.Single(c => c.contractNumber == "CHILD-2").description);
            Assert.AreEqual("REVISED CHILD DESCRIPTION 3", actualMashedResult.contracts.Single(c => c.contractNumber == "CHILD-3").description);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Masher_ShouldRetainCrmContractModificationValuesInMashedAllocation()
        {
            DateTime stopNewStartsDate = new DateTime(2020, 10, 31, 0, 0, 0, DateTimeKind.Utc);
            DateTime inflightStopNewStartsDate = new DateTime(2020, 11, 30, 0, 0, 0, DateTimeKind.Utc);
            const string newStartsSuspendedReason = "Inadequate Financial Health";
            const string inflightNewStartsSuspendedReason = "Other";

            // arrange
            contractType crmContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "TEST-1234",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "ALLOC-1234",
                                StopNewStartsDate = stopNewStartsDate,
                                InflightStopNewStartsDate = inflightStopNewStartsDate,
                                NewStartsSuspendedReason = newStartsSuspendedReason,
                                InflightNewStartsSuspendedReason = inflightNewStartsSuspendedReason
                            }
                        }
                    }
                }
            };
            contractType importContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = Intent.Amendment,
                        contractNumber = "TEST-1234",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = Intent.Amendment,
                                contractAllocationNumber = "ALLOC-1234"
                            }
                        }
                    }
                }
            };

            Masher masher = new Masher();

            // act
            contractType result = masher.Mash(crmContract, importContract);

            // assert
            contractAllocation mashedAllocation = result.contracts.Single().contractAllocations.Single();
            Assert.AreEqual(stopNewStartsDate, mashedAllocation.StopNewStartsDate, "StopNewStartsDate not copied");
            Assert.AreEqual(inflightStopNewStartsDate, mashedAllocation.InflightStopNewStartsDate, "InflightStopNewStartsDate not copied");
            Assert.AreEqual(newStartsSuspendedReason, mashedAllocation.NewStartsSuspendedReason, "NewStartsSuspendedReason not copied");
            Assert.AreEqual(inflightNewStartsSuspendedReason, mashedAllocation.InflightNewStartsSuspendedReason, "InflightNewStartsSuspendedReason not copied");
        }
    }
}
