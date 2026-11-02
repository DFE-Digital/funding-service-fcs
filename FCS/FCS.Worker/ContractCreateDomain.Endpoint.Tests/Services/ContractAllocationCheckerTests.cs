namespace ContractCreateDomain.Endpoint.Tests.Services
{
    using System;
    using System.Collections.Generic;
    using Castle.Components.DictionaryAdapter;
    using Endpoint.Infrastructure;
    using Endpoint.Services;
    using Endpoint.Services.DTOs;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ContractAllocationCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSamePlannedValues_ShouldReturnFalseWhenThePlannedValuesDoNotMatch()
        {
            // arrange

            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019),
                    new CrmDeliverablePeriod(9, "201909", 2, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 9,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    }
                }
            };
            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSamePlannedValues(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { },b => Assert.Fail("We have returned a success where we should have failed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSamePlannedValues_ShouldReturnTrueWhenThePlannedValuesDoMatch()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019),
                    new CrmDeliverablePeriod(9, "201909", 2, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1,
                                year = 2019
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2,
                                year = 2019
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 3,
                                year = 2019
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 4,
                                year = 2019
                            }
                        }
                    }
                }
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSamePlannedValues(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { Assert.Fail("We have returned a fail where we should have succeeded");}, b => { });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSamePlannedValues_ShouldReturnFalseWhenThePlannedValuesMatchTreatingNullAsZero()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", null, 2019),
                    new CrmDeliverablePeriod(9, "201909", 2, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 0,
                                year = 2019
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2,
                                year = 2019
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 3,
                                year = 2019
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 4,
                                year = 2019
                            }
                        }
                    }
                }
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSamePlannedValues(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { Assert.Fail("We have returned a fail where we should have succeeded"); }, b => {  });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSamePlannedValues_ShouldReturnFalseWhenThereIsNoPeriodInCrm()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 9,
                                plannedValue = 3
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 4
                            }
                        }
                    }
                }
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSamePlannedValues(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { }, b => Assert.Fail("We have returned a success where we should have failed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSameDeliverableCodes_ShouldReturnFalseWhenTheDeliverableCodesDoNotMatch()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 3
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    }
                }
            };
            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSameDeliverableCodes(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { }, b => Assert.Fail("We have returned a success where we should have failed"));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSameDeliverableCodes_ShouldReturnTrueWhenTheDeliverableCodesMatch()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y", null, null, new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importAllocation = new contractAllocation
            {
                contractDeliverables = new List<contractDeliverable>
                {
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 1
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 2
                            }
                        }
                    },
                    new contractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new EditableList<contractDeliverablePeriodType>
                        {
                            new contractDeliverablePeriodType
                            {
                                periodName = "201908",
                                period = 8,
                                plannedValue = 3
                            },
                            new contractDeliverablePeriodType
                            {
                                periodName = "201909",
                                period = 9,
                                plannedValue = 4
                            }
                        }
                    }
                }
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSameDeliverableCodes(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importAllocation));

            // assert
            either.Match(b => { Assert.Fail("We have returned a fail where we should have succeeded"); }, b => { });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSameAllocationDates_ShouldReturnTrueWhenTheDatesMatch()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y",
                new DateTime(2019, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                new DateTime(2019, 12, 31, 0, 0, 0, DateTimeKind.Utc),
                new List<CrmDeliverable>
            {
                new CrmDeliverable("1", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 1, 2019)
                }),
                new CrmDeliverable("2", new List<CrmDeliverablePeriod>
                {
                    new CrmDeliverablePeriod(8, "201908", 3, 2019),
                    new CrmDeliverablePeriod(9, "201909", 4, 2019)
                })
            });

            contractAllocation importedAllocation = new contractAllocation
            {
                startDate = new DateTime(2019, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2019, 12, 31, 0, 0, 0, DateTimeKind.Utc),
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSameAllocationDates(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importedAllocation));

            // assert
            either.Match(b => { Assert.Fail("We have returned a fail where we should have succeeded"); }, b => { });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationChecker_HasTheSameAllocationDates_ShouldReturnFalseWhenTheDatesDoNotMatch()
        {
            // arrange
            CrmAllocation crmAllocation = new CrmAllocation("Y",
                 new DateTime(2019, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                 new DateTime(2019, 12, 31, 0, 0, 0, DateTimeKind.Utc),
                 null
               );


            contractAllocation importedAllocation = new contractAllocation
            {
                startDate = new DateTime(2019, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                endDate = new DateTime(2019, 12, 30, 0, 0, 0, DateTimeKind.Utc),
            };

            // act
            Either<bool, CrmAllocationAndImportAllocation> either = ContractAllocationChecker.HasTheSameAllocationDates(
                new CrmAllocationAndImportAllocation(crmAllocation: crmAllocation, importAllocation: importedAllocation));

            // assert
            either.Match(b => { }, b => { Assert.Fail("We have returned a success where we should have failed"); });
        }
    }
}
