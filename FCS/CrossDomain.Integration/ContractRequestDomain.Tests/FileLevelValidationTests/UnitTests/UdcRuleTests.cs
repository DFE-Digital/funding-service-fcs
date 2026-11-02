namespace ContractRequestDomain.Tests.FileLevelValidationTests.UnitTests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Linq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Validation.UDC;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    
    [TestClass]
    public class UdcRuleTests
    {
        #region MustSpecifyDeliverableDetailsUpdate (UDC-006)

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsUpdateRule_ShouldPassWhenDeliverableDetailsAreSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsUpdateRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsUpdateRule_ShouldFailWhenFundingStreamCodeNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "AllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStream Code", Value = " "},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsUpdateRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsUpdateRule_ShouldFailWhenDeliverableCodeNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "AllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStream Code", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = ""},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsUpdateRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsUpdateRule_ShouldFailWhenAllocationNumberNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "FundingStream Code", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsUpdateRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        #endregion

        #region MustSpecifyDeliverableDetailsDelete (UDC-008)

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsDeleteRule_ShouldPassWhenDeliverableDetailsAreSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Delete Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsDeleteRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsDeleteRule_ShouldFailWhenFundingStreamCodeNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "AllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStream Code", Value = " "},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Delete Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsDeleteRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsDeleteRule_ShouldFailWhenDeliverableCodeNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "AllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStream Code", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = ""},
                                    new cellType {columnName = "CRMIntent", Value = "Delete Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsDeleteRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void MustSpecifyDeliverableDetailsDeleteRule_ShouldFailWhenAllocationNumberNotSpecified()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType
                    {
                        name = "Deliverable",
                        row = new[]
                        {
                            new rowType
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "FundingStream Code", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Delete Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new MustSpecifyDeliverableDetailsDeleteRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        #endregion

        #region ContractAllocationMustHaveRelatedContract (UDC-017)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveRelatedContractRule_ShouldPassWhenAllocationHasACorrespondingContract()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType()
                    {
                        name = "Contract",
                        row = new[]
                        {
                            new rowType()
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    },
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new ContractAllocationMustHaveRelatedContractRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveRelatedContractRule_ShouldFailWhenAllocationHasNoCorrespondingContract_OnContractTab()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType()
                    {
                        name = "Contract",
                        row = new[]
                        {
                            new rowType()
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    },
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_2345"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new ContractAllocationMustHaveRelatedContractRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Contract Allocation, Row: 2 - ")));
        }

        #endregion

        #region ContractAllocationMustHaveRelatedContract (UDC-017b)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveRelatedContractBRule_ShouldPassWhenAllocationHasACorrespondingContract()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType()
                    {
                        name = "Contract",
                        row = new[]
                        {
                            new rowType()
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    },
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new ContractAllocationMustHaveRelatedContractBRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_ContractAllocationMustHaveRelatedContractBRule_ShouldFailWhenAllocationHasNoCorrespondingContract_OnContractTab()
        {
            // Arrange
            var import = new dataLoadResults
            {
                workbook = new[]
                {
                    new sheetType()
                    {
                        name = "Contract",
                        row = new[]
                        {
                            new rowType()
                            {
                                rowNumber = 1,
                                cell = new[]
                                {
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    },
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_2345"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new ContractAllocationMustHaveRelatedContractBRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Contract Allocation, Row: 2 - ")));
        }

        #endregion

        #region DeliverableMustHaveRelatedContract (UDC-018)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveRelatedContractRule_ShouldPassWhenDeliverableHasCorrespondingAllocationWithCorrespondingContract()
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new DeliverableMustHaveRelatedContractRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveRelatedContractRule_ShouldFailWhenDeliverableHasNoCorrespondingAllocationWithNoCorrespondingContract()
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2019"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new DeliverableMustHaveRelatedContractRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        #endregion

        #region DeliverableMustHaveRelatedContract (UDC-018b)

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveRelatedContractBRule_ShouldPassWhenDeliverableHasCorrespondingAllocationWithCorrespondingContract()
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new DeliverableMustHaveRelatedContractBRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsFalse(errors.Any());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ApplyRule_DeliverableMustHaveRelatedContractBRule_ShouldFailWhenDeliverableHasNoCorrespondingAllocationWithNoCorrespondingContract()
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2018"},
                                    new cellType {columnName = "ContractNumber", Value = "UPBLK_1234"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft"}
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
                                    new cellType {columnName = "ContractAllocationNumber", Value = "ASTO-2019"},
                                    new cellType {columnName = "FundingStreamCode", Value = "ASTO"},
                                    new cellType {columnName = "DeliverableCode", Value = "2"},
                                    new cellType {columnName = "CRMIntent", Value = "Update Draft Amendment"}
                                }
                            }
                        }
                    }
                }
            };

            // Act
            var rule = new DeliverableMustHaveRelatedContractBRule();
            var errors = rule.GetFailureForItem(import);

            // Assert
            Assert.IsTrue(errors.Exists(x => x.Value.Contains("Sheet: Deliverable, Row: 2 - ")));
        }

        #endregion
    }
}