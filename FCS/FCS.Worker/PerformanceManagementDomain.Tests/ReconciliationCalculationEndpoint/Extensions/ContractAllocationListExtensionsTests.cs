namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Extensions;

    [TestClass]
    public class ContractAllocationListExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldLimitReconcileValueForOverDelivery_WhenCappedClaimValueGreaterThanLimit()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 10301
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                0,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
                );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

            // assert
            Assert.AreEqual(300, amountSummary.ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldNotLimitReconcileValueForOverDelivery_WhenCappedClaimValueLessThanLimit()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 10299
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                0,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

            // assert
            Assert.AreEqual(299, amountSummary.ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldNotLimitReconcileValueForOverDelivery_WhenCappedClaimValueEqualsLimit()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 10300
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                0,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

            // assert
            Assert.AreEqual(300, amountSummary.ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldCalculationReconciliationForUnderDelivery()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 9800
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                3,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, -110);

            // assert
            Assert.AreEqual(-310, amountSummary.ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldNotLimitReconcileValueForOverDelivery_WhenCappedClaimValueGtrThanLimitAndUnderDeliverySet()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 10299
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                3,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

            // assert
            Assert.AreEqual(299, amountSummary.ReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldWorkForOverDeliveryCap()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 9800,
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                3,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 600);

            // assert
            Assert.AreEqual(300, amountSummary.ProposedReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_ApportionProposedReconciliationToAllocations_ShouldCalculateProposedReconciliation()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        AdjustedCappedClaimValue = 9740,
                        CappedClaimedValue = 9800
                    }
                }
            };

            AmountSummary fundingClaimGroupAmounts = new AmountSummary
            {
                AdjustedCappedClaimValue = 9740,
                PlannedValue = 10000,
                ProposedReconciliationValue = -260
            };

            // act

            contractAllocations.ApportionProposedReconciliationToAllocations(fundingClaimGroupAmounts);

            // assert
            Assert.AreEqual(fundingClaimGroupAmounts.ProposedReconciliationValue, contractAllocations.First().Amounts.ProposedReconciliationValue, "The ProposedReconciliationValue is not correct");
            Assert.AreEqual(fundingClaimGroupAmounts.AdjustedCappedClaimValue, contractAllocations.First().Amounts.AdjustedCappedClaimValue, "The ProposedReconciliationValue is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_ApportionProposedReconciliationToAllocations_ShouldWorkForPositiveProposedValue()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 9800,
                    }
                }
            };

            AmountSummary fundingClaimGroupAmounts = new AmountSummary
            {
                AdjustedCappedClaimValue = 10400,
                PlannedValue = 10000,
                ProposedReconciliationValue = 300
            };

            // act

            contractAllocations.ApportionProposedReconciliationToAllocations(fundingClaimGroupAmounts);

            // assert
            Assert.AreEqual(fundingClaimGroupAmounts.ProposedReconciliationValue, contractAllocations.First().Amounts.ProposedReconciliationValue, "The ProposedReconciliationValue is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ShouldWorkForUnderDeliveryCap()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary
                    {
                        PlannedValue = 10000,
                        CappedClaimedValue = 9499,
                    }
                }
            };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                3,
                3,
                underDeliveryRecoveryAmount: UnderDeliveryRecoveryAmount.Full
            );

            // act

            AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 600);

            // assert
            Assert.AreEqual(99, amountSummary.ProposedReconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_ApportionAdjustedCappedClaimValueToAllocations_ShouldPopulateAdjustedCappedClaimOnAllocation()
        {
            // arrange
            List<ContractAllocation> contractAllocations = new List<ContractAllocation>
            {
                new ContractAllocation
                {
                    Amounts = new AmountSummary()
                }
            };

            const decimal adjustedCappedClaimValue = 10;

            // act

            contractAllocations.ApportionAdjustedCappedClaimValueToAllocations(adjustedCappedClaimValue);

            // assert
            contractAllocations.ForEach(a =>
            {
                Assert.AreEqual(a.Amounts.AdjustedCappedClaimValue, adjustedCappedClaimValue);
            });
        }
    }

    /// <summary>
    /// These tests all relate to a spreadsheet of examples ..\TestResources\FCR 19-20 Scenarios v3.xlsx
    /// </summary>
    [TestClass]
    public class ContractAllocationListExtensionsTests_Final_1920
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEBC_ASCL1920()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 10000, 0, 1),
                    (10000, 6801, 0, 2),
                    (10000, 6800, 0, 3),
                    (10000, 6799, -1, 4),
                    (10000, 0, -6800, 5),
                    (10000, 10299, 299, 6),
                    (10000, 10300, 300, 7),
                    (10000, 10301, 300, 8),
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                -32,
                3,
                UnderDeliveryRecoveryAmount.Excess
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEBC_19TRN1920()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 10000, 0, 1),
                    (10000, 1101, 0, 2),
                    (10000, 1100, 0, 3),
                    (10000, 1099, -1, 4),
                    (10000, 0, -1100, 5),
                    (10000, 10999, 999, 6),
                    (10000, 11000, 1000, 7),
                    (10000, 11001, 1000, 8),
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                -89,
                10,
                UnderDeliveryRecoveryAmount.Excess
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEB_ASLS1920()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 10000, 0, 1),
                    (10000, 9999, -1, 2),
                    (10000, 0, -10000, 3),
                    (10000, 10299, 299, 4),
                    (10000, 10300, 300, 5),
                    (10000, 10301, 300, 6)
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                0,
                3,
                UnderDeliveryRecoveryAmount.Full
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEB_19TRLS1920()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 10000, 0, 1),
                    (10000, 9999, -1, 2),
                    (10000, 0, -10000, 3),
                    (10000, 10999, 999, 4),
                    (10000, 11000, 1000, 5),
                    (10000, 11001, 1000, 6)
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                0,
                10,
                UnderDeliveryRecoveryAmount.Full
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ALLBC1920()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 10000, 0, 1),
                    (10000, 3001, 0, 2),
                    (10000, 3000, 0, 3),
                    (10000, 2999, -1, 4),
                    (10000, 0, -3000, 5),
                    (10000, 10001, 0, 6),
                    (10000, 21000, 0, 7)
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                false,
                0,
                0,
                null,
                -70,
                null,
                UnderDeliveryRecoveryAmount.Excess
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEBC_19TRN2021()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 0, -10000, 1),
                    (10000, 8999, -1, 2),
                    (10000, 9000, 0, 3),
                    (10000, 9000, 0, 4),
                    (10000, 10000, 0, 5),
                    (10000, 12999, 2999, 6),
                    (10000, 13000, 3000, 7),
                    (10000, 13001, 3000, 8),
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                -10,
                30,
                UnderDeliveryRecoveryAmount.ExcessUnlessNoDelivery
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_AEBC_ASCL2021()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 0, -10000, 1),
                    (10000, 8999, -1, 2),
                    (10000, 9000, 0, 3),
                    (10000, 9001, 0, 4),
                    (10000, 10000, 0, 5),
                    (10000, 10299, 299, 6),
                    (10000, 10300, 300, 7),
                    (10000, 103001, 300, 8),

                    (10000, 8999, -1, 17),
                    (10000, 9000, 0, 18),
                    (10000, 9001, 0, 19),
                    (10000, 10000, 0, 20),
                    (10000, 10000, 0, 21),
                    (10000, 10299, 299, 22),
                    (10000, 10300, 300, 23),
                    (10000, 103001, 300, 24)
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                true,
                0,
                0,
                null,
                -10,
                3,
                UnderDeliveryRecoveryAmount.ExcessUnlessNoDelivery
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationListExtensions_CalculateAmountSummaryForClaimGroup_ALLBC2021()
        {
            // arrange
            List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)> testDataRows =
                new List<(decimal plannedValue, decimal claimValue, decimal expectedReconciliation, int scenario)>
                {
                    (10000, 0, -10000, 1),
                    (10000, 8999, -1, 2),
                    (10000, 9000, 0, 3),
                    (10000, 9001, 0, 4),
                    (10000, 10000, 0, 5),
                    (10000, 10001, 0, 6),
                    (10000, 21000, 0, 7),
                };

            ClaimReconciliationBehaviour behaviour = new ClaimReconciliationBehaviour(
                "",
                "",
                true,
                true,
                false,
                0,
                0,
                null,
                -10,
                null,
                UnderDeliveryRecoveryAmount.ExcessUnlessNoDelivery
            );

            testDataRows.ForEach(testData =>
            {
                List<ContractAllocation> contractAllocations = new List<ContractAllocation>
                {
                    new ContractAllocation
                    {
                        Amounts = new AmountSummary
                        {
                            PlannedValue = testData.plannedValue,
                            CappedClaimedValue = testData.claimValue
                        }
                    }
                };
                // act
                AmountSummary amountSummary = contractAllocations.CalculateAmountSummaryForClaimGroup(behaviour, 0);

                // assert
                Assert.AreEqual(testData.expectedReconciliation, amountSummary.ProposedReconciliationValue, $"The test has failed for scenario: {testData.scenario}");
            });
        }
    }
}