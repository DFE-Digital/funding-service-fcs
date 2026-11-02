namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class UpdateDraftContractValidationRuleTests
    {
        #region ContractMustBeInCorrectState (UDC-002)
        private contractType CreateTestContractWithStatus(string status, string subStatus)
        {
            return new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractNumber = "SFA1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        status = status,
                        subStatus = subStatus,
                        contractNumber = "1"
                    }
                }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldNotReturnFailures_WhenStatusDraftAndSubStatusUnassigned()
        {
            // Arrange                   
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Draft, ContractStatus.Unassigned)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldNotReturnFailures_WhenStatusDraftAndSubStatusInReview()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Draft, ContractStatus.InReview)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldNotReturnFailures_WhenStatusDraftAndSubStatusAwaitingDocumentation()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Draft, ContractStatus.AwaitingDocumentation)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldReturnFailures_WhenStatusDraftAndSubStatusMergeInDocument()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Draft, ContractStatus.MergeInProgress)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldReturnFailures_WhenStatusCorrectSubStatusIncorrect()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Approved, ContractStatus.Unassigned)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldReturnFailures_WhenStatusIncorrectCorrectSubStatusCorrect()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Draft, ContractStatus.Approved)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustBeInCorrectStateRule_ShouldReturnFailures_WhenStatusIncorrectCorrectSubStatusIncorrect()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = CreateTestContractWithStatus(ContractStatus.Approved, ContractStatus.Approved)
            };
            // Act
            var rule = new ContractMustBeInCorrectStateRule();
            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustSpecifyMasterContractNumber (UDC-003)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustSpecifyMasterContractNumberRule_ShouldNotReturnFailures_WhenMasterContractNumberSpecified()
        {
            // Arrange
            var masterContract = new contractType
            {
                CRMIntent = intent.UpdateDraft,
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contractNumber = "SFA1",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "1"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyMasterContractNumberRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustSpecifyMasterContractNumberRule_ShouldReturnFailures_WhenMasterContractNumberNotSpecified
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                CRMIntent = intent.UpdateDraft,
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractNumber = "1"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyMasterContractNumberRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustSpecifyContractNumber (UDC-004)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustSpecifyContractNumberRule_ShouldNotReturnFailures_WhenContractNumberSpecified()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractNumberRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustSpecifyContractNumberRule_ShouldReturnFailures_WhenContractNumberNotSpecified()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractNumberRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustSpecifyContractNumberRule_ShouldReturnFailures_WhenMultipleContractNumbersNotSpecified()
        {
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT
                    },
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractNumberRule();

            Assert.AreEqual(2, rule.GetFailuresForItem(contractRequest).Count());
        }

        public void ApplyRule_MustSpecifyContractNumberRule_ShouldReturnFailures_WhenContractNumberNotSpecifiedInContractSet()
        {
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT
                    },
                    new contractType
                    {
                        CRMIntent = intent.UpdateDraft,
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "TEST"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractNumberRule();

            Assert.AreEqual(1, rule.GetFailuresForItem(contractRequest).Count());
        }

        #endregion

        #region MustSpecifyContractAllocationNumberUpdate (UDC-005)

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberUpdateRule_ShouldNotReturnFailures_WhenContractAllocationNumberSpecified
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft,
                                contractAllocationNumber = "1"
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberUpdateRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberUpdateRule_ShouldReturnFailures_WhenContractAllocationNumberNotSpecified
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberUpdateRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberUpdateRule_ShouldReturnMultipleFailures_WhenContractAllocationNumberNotSpecifiedForMultipleContracts
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft
                            }
                        }
                    },
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberUpdateRule();

            Assert.AreEqual(2, rule.GetFailuresForItem(contractRequest).Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberUpdateRule_ShouldReturnFailure_WhenContractAllocationNumberNotSpecifiedInOneOutOfMultipleContracts
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft
                            }
                        }
                    },
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.UpdateDraft,
                                contractAllocationNumber = "TEST"
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberUpdateRule();

            Assert.AreEqual(1, rule.GetFailuresForItem(contractRequest).Count());
        }

        #endregion

        #region MustSpecifyContractAllocationNumberDelete (UDC-007)

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberDeleteRule_ShouldNotReturnFailures_WhenContractAllocationNumberSpecified
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft,
                                contractAllocationNumber = "1"
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberDeleteRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberDeleteRule_ShouldReturnFailures_WhenContractAllocationNumberNotSpecified
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberDeleteRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberDeleteRule_ShouldReturnMultipleFailures_WhenContractAllocationNumberNotSpecifiedForMultipleContracts
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft
                            }
                        }
                    },
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberDeleteRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void
            ApplyRule_MustSpecifyContractAllocationNumberDeleteRule_ShouldReturnFailure_WhenContractAllocationNumberNotSpecifiedForOneOfMultipleContracts
            ()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft
                            }
                        }
                    },
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.DeleteDraft,
                                contractAllocationNumber = "TEST"
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustSpecifyContractAllocationNumberDeleteRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustHaveMatchingContractInFct (UDC-009)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingContractInFctRule_ShouldNotReturnFailures_WhenCrmNotPresentIsFalse()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingContractInFctRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingContractInFctRule_ShouldReturnFailures_WhenCrmNotPresentIsTrue()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        crmNotPresent = true
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingContractInFctRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustHaveMatchingContractAllocationInFct (UDC-010)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingContractAllocationInFctRule_ShouldNotReturnFailures_WhenCrmNotPresentIsFalse()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1"
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingContractAllocationInFctRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingContractAllocationInFctRule_ShouldReturnFailures_WhenCrmNotPresentIsTrue()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                crmNotPresent = true
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingContractAllocationInFctRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustHaveMatchingMasterContractInFct (UDC-011)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingMasterContractInFctRule_ShouldNotReturnFailures_WhenCrmNotPresentIsFalse()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractNumber = "12345"
                }
            };

            // Act
            var rule = new MustHaveMatchingMasterContractInFctRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingMasterContractInFctRule_ShouldReturnFailures_WhenCrmNotPresentIsTrue()
        {
            // Arrange
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractNumber = "12345",
                    crmNotPresent = true
                }
            };

            // Act
            var rule = new MustHaveMatchingMasterContractInFctRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region MustHaveMatchingDeliverableInFct (UDC-012)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingDeliverableInFctRule_ShouldNotReturnFailures_WhenCrmNotPresentIsFalse()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        CRMIntent = intent.DeleteDraft,
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2015,
                                            fundingStreamCode = "1"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingDeliverableInFctRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_MustHaveMatchingDeliverableInFctRule_ShouldReturnFailures_WhenCrmNotPresentIsTrue()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractAllocationNumber = "1",
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        CRMIntent = intent.DeleteDraft,
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = 2015,
                                            fundingStreamCode = "1"
                                        },
                                        crmNotPresent = true
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new MustHaveMatchingDeliverableInFctRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region ContractAllocationMustHaveActiveUkprn (UDC-013)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveActiveUkprnRule_ShouldNotReturnFailures_WhenUkprnActive()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.New
                            },
                            new contractAllocation()
                        }
                    }
                },
                contractor = new contractor
                {
                    organisationStatus = OrgStatus.Active
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveActiveUkprnRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveActiveUkprnRule_ShouldReturnFailures_WhenUkprnInactive()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractor = new contractor
                        {
                            organisationStatus = "Inactive"
                        },
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.New
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveActiveUkprnRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }
        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveActiveUkprnRule_ShouldReturnFailures_WhenUkprnInLiquidation()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractor = new contractor
                        {
                            organisationStatus = "In Liquidation"
                        },
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.New
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveActiveUkprnRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveActiveUkprnRule_ShouldReturnFailures_WhenUkprnDissolved()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractor = new contractor
                        {
                            organisationStatus = "Dissolved"
                        },
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.New
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveActiveUkprnRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveActiveUkprnRule_ShouldReturnFailures_WhenUkprnDeleted()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractor = new contractor
                        {
                            organisationStatus = "Deleted"
                        },
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                CRMIntent = intent.New
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveActiveUkprnRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }
        #endregion

        #region DeliverableMustHaveActiveUkprn (UDC-014)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveActiveUkprnRule_ShouldNotReturnFailures_WhenUkprnActive()
        {
            // Arrange
            var masterContract = new contractType
            {
                contractor = new contractor
                {
                    organisationStatus = OrgStatus.Active
                },
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        CRMIntent = intent.New
                                    },
                                    new contractDeliverable()
                                }
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new DeliverableMustHaveActiveUkprnRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveActiveUkprnRule_ShouldReturnFailures_WhenUkprnInactive()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractor = new contractor
                        {
                            organisationStatus = "Dissolved"
                        },
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable
                                    {
                                        CRMIntent = intent.New
                                    },
                                    new contractDeliverable()
                                }
                            },
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new DeliverableMustHaveActiveUkprnRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region ContractMustHaveAtLeastOneAllocation (UDC-015)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustHaveAtLeastOneAllocationRule_ShouldNotReturnFailures_WhenOneAllocationRemains()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractMustHaveAtLeastOneAllocationRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractMustHaveAtLeastOneAllocationRule_ShouldReturnFailures_WhenNoAllocationsRemain()
        {
            // Arrange
            var masterContract = new contractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1"
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractMustHaveAtLeastOneAllocationRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region ContractAllocationMustHaveAtLeastOneDeliverable (UDC-016)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveAtLeastOneDeliverableRule_ShouldNotReturnFailures_WhenOneDeliverableRemains()
        {
            // Arrange
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation
                            {
                                contractDeliverables = new List<contractDeliverable>
                                {
                                    new contractDeliverable()
                                }
                            }
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveAtLeastOneDeliverableRule();

            Assert.IsFalse(rule.GetFailuresForItem(contractRequest).Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveAtLeastOneDeliverableRule_ShouldReturnFailures_WhenNoDeliverablesRemain()
        {
            var masterContract = new contractType
            {
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        contractNumber = "1",
                        contractAllocations = new List<contractAllocation>
                        {
                            new contractAllocation()
                        }
                    }
                }
            };

            var contractRequest = new contractRequestType
            {
                contract = masterContract
            };

            // Act
            var rule = new ContractAllocationMustHaveAtLeastOneDeliverableRule();

            Assert.IsTrue(rule.GetFailuresForItem(contractRequest).Any());
        }

        #endregion

        #region ContractAmendmentCannotHaveExistingDraftContractRule (UDC-019)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAmendmentCannotHaveExistingDraftContractRule_ShouldNotReturnFailures_WhenDraftContractNotPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsDraftContractWithContractNumberPresentInCrm = false
                        },
                        new contractType
                        {
                            IsDraftContractWithContractNumberPresentInCrm = false
                        }
                    }
                }
            };

            var failures = new ContractAmendmentCannotHaveExistingDraftContractRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAmendmentCannotHaveExistingDraftContractRule_ShouldReturnFailures_WhenDraftContractPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsDraftContractWithContractNumberPresentInCrm = false
                        },
                        new contractType
                        {
                            IsDraftContractWithContractNumberPresentInCrm = true
                        }
                    }
                }
            };

            var failures = new ContractAmendmentCannotHaveExistingDraftContractRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
            Assert.AreEqual(1, failures.Count());
        }

        #endregion

        #region ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule (UDC-020)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule_ShouldNotReturnFailures_WhenApprovedContractPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true
                        },
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true
                        }
                    }
                }
            };

            var failures = new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule_ShouldReturnFailures_WhenApprovedContractAndWithdrawnContractNotPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = false
                        }
                    }
                }
            };

            var failures = new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
            Assert.AreEqual(1, failures.Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule_ShouldNotReturnFailures_WhenWithdrawnAndApprovedContractsPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true
                        },
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true
                        }
                    }
                }
            };

            var failures = new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        #endregion

        #region UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule (UDC-021)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule_ShouldNotReturnFailures_WhenApprovedContractPresentAndDraftContractPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true,
                            IsDraftContractWithContractNumberPresentInCrm = true
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule_ShouldReturnFailures_WhenApprovedContractPresentAndDraftContractNotPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = true,
                            IsDraftContractWithContractNumberPresentInCrm = false
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule_ShouldReturnFailures_WhenApprovedContractNotPresentAndDraftContractPresent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            IsApprovedContractWithContractNumberPresentInCrm = false,
                            IsDraftContractWithContractNumberPresentInCrm = true
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        #endregion

        #region UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule (UDC-022)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule_ShouldNotReturnFailures_WhenAmendmentTypeIsNone()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            amendmentType = amendmentType.None
                        }
                    }
                }
            };

            var failures = new UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule_ShouldReturnFailures_WhenAmendmentTypeIsNotification()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            amendmentType = amendmentType.Notification
                        }
                    }
                }
            };

            var failures = new UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule_ShouldReturnFailures_WhenAmendmentTypeIsVariation()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            amendmentType = amendmentType.Variation
                        }
                    }
                }
            };

            var failures = new UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        #endregion

        #region UpdateDraftAmendmentCannotDeleteApprovedAllocationRule (UDC-023)

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDraftAmendmentCannotDeleteApprovedAllocationRule_ErrorLevel_ShouldReturn_CorrectErrorLevel()
        {
            var rule = new UpdateDraftAmendmentCannotDeleteApprovedAllocationRule();
            Assert.AreEqual(errorInfoTypeLevel.Allocation, rule.ErrorLevel);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedAllocationRule_ShouldNotReturnFailures_WhenNoApprovedAllocationsDeleted()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001"
                                },
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-002"
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-001"
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-002"
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.DeleteDraftAmendment,
                                    contractAllocationNumber = "ADDED-BY-AMENDMENT-ALLOC-003"
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.New,
                                    contractAllocationNumber = null,
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedAllocationRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedAllocationRule_ShouldReturnFailures_WhenApprovedAllocationDeleted()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001"
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.DeleteDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-001"
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedAllocationRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedAllocationRule_ShouldReturnFailures_WhenApprovedAllocationDeleted_WithAlternateDeleteDraftIntent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001"
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.DeleteDraft,
                                    contractAllocationNumber = "APPROVED-ALLOC-001"
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedAllocationRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        #endregion

        #region UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule (UDC-024)

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule_ErrorLevel_ShouldReturn_CorrectErrorLevel()
        {
            var rule = new UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule();
            Assert.AreEqual(errorInfoTypeLevel.Deliverable, rule.ErrorLevel);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule_ShouldNotReturnFailures_WhenNoApprovedDeliverablesDeleted()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001",
                                    DeliverableCodes = new[] { 1, 2 }
                                },
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-002",
                                    DeliverableCodes = new[] { 1, 2 }
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-001",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.UpdateDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        },
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.UpdateDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 2
                                            }
                                        }
                                    }
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-002",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.UpdateDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        },
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.UpdateDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 2
                                            }
                                        },
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.DeleteDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 3
                                            }
                                        }
                                    }
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.DeleteDraftAmendment,
                                    contractAllocationNumber = "ADDED-BY-AMENDMENT-ALLOC-003",
                                    fundingStreamCode = "FSC-003",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.DeleteDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        },
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.DeleteDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 2
                                            }
                                        }
                                    }
                                },
                                new contractAllocation
                                {
                                    CRMIntent = intent.New,
                                    contractAllocationNumber = null,
                                    fundingStreamCode = "FSC-004",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.New,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        },
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.New,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 2
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule().GetFailuresForItem(contractRequest);

            Assert.IsFalse(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule_ShouldReturnFailures_WhenApprovedDeliverableDeleted()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001",
                                    DeliverableCodes = new[] { 1, 2 }
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-001",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.DeleteDraftAmendment,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule_ShouldReturnFailures_WhenApprovedDeliverableDeleted_WithAlternateDeleteDraftIntent()
        {
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            ApprovedAllocationValues = new List<AllocationValueData>
                            {
                                new AllocationValueData
                                {
                                    ContractAllocationNumber = "APPROVED-ALLOC-001",
                                    DeliverableCodes = new[] { 1, 2 }
                                }
                            },
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    CRMIntent = intent.UpdateDraftAmendment,
                                    contractAllocationNumber = "APPROVED-ALLOC-001",
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            CRMIntent = intent.DeleteDraft,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var failures = new UpdateDraftAmendmentCannotDeleteApprovedDeliverableRule().GetFailuresForItem(contractRequest);

            Assert.IsTrue(failures.Any());
        }

        #endregion

    }
}
