namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation;

    [TestClass]
    public class TenderAwardRefMustBeUniqueAmongstFilesEsfAllocationsTests
    {
        #region ESF

        private const string EsfFundingStreamCode = "ESF 201420";

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldPassWhenAllTenderAwardReferencesAreUnique()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "29802/23-002-01-02/12323121"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "39802/23-002-01-02/12323121"},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldPassWhenAllTenderAwardReferencesAreEmptyAndIntentUpdateDraft()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldFailWhenAllTenderAwardReferencesAreEmptyAndIntentNew()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsTrue(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldPassWhenTenderAwardReferencesAreEmptyForUpdateDraftAndPresentForNew()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "Some val"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "Some val2"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 3,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2020"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 4,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2021"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"},
                                    new cellType {columnName = "TenderAwardReference", Value = string.Empty},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldPassIfTenderAwardReferenceColumnIsMissing()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForEsfAllocations_ShouldFailWhenThereAreNonUniqueTenderAwardReferences()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "29802/23-002-01-02/12323121"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "29802/23-002-01-02/12323121"},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = EsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            //CollectionAssert.AreEquivalent(new List<errorInfo> {}, errors.ToList());
            Assert.IsTrue(errors.Exists(e => e.Value == "Sheet: Contract Allocation, Row: 2 - 2 Contract Allocations cannot have the same Tender Award Reference within the Bulk Import file or the CRM system."));
            Assert.IsTrue(errors.Exists(e => e.Value == "Sheet: Contract Allocation, Row: 3 - 2 Contract Allocations cannot have the same Tender Award Reference within the Bulk Import file or the CRM system."));
        }

        #endregion ESF

        #region NonESF

        private const string NonEsfFundingStreamCode = "EOP";

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations_ForNonEsfAllocations_ShouldPassWhenThereAreNonUniqueTenderAwardReferences()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Contract Allocation",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = NonEsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "29802/23-002-01-02/12323121"},
                                }
                            },
                            new rowType
                            {
                                rowNumber = 2,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2019"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = NonEsfFundingStreamCode},
                                    new cellType {columnName = "CRMIntent", Value = "New"},
                                    new cellType {columnName = "TenderAwardReference", Value = "29802/23-002-01-02/12323121"},
                                }
                            }
                        }
                    },
                    new sheetType()
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ESF-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = NonEsfFundingStreamCode},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "New"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new TenderAwardRefMustBeUniqueAmongstFilesEsfAllocations();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsNotNull(errors);
            Assert.IsFalse(errors.Any());
        }

        #endregion NonESF
    }
}
