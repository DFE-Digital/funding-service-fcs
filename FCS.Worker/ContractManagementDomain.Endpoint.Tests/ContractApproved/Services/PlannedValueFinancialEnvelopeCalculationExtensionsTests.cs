namespace ContractManagementDomain.Endpoint.Tests.ContractApproved.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Endpoint.ContractApproved.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class PlannedValueFinancialEnvelopeCalculationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueFinancialEnvelopeCalculator_GetFirstEnvelope_ShouldReturnAggregatedValueReflectingFinancialYearWithinAcademicYear()
        {
            // arrange
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = GetDeliverablePeriods();

            // act
            decimal firstEnvelope = deliverablePeriods.GetFirstEnvelope(2018);

            // assert
            Assert.AreEqual(11200m, firstEnvelope, "First envelope was not calculated correctly");
        }


        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueFinancialEnvelopeCalculator_GetFirstEnvelope_WhereAllStartYearAndEndYearAreTheSame()
        {
            // arrange
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = GetDeliverablePeriodsShort();

            // act
            decimal firstEnvelope = deliverablePeriods.GetFirstEnvelope(2018);

            // assert
            Assert.AreEqual(5000, firstEnvelope, "First envelope was not calculated correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueFinancialEnvelopeCalculator_GetSecondEnvelope_ShouldReturnAggregatedValueReflectingFinancialYearWithinAcademicYear()
        {
            // arrange
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = GetDeliverablePeriods();

            // act
            decimal secondEnvelope = deliverablePeriods.GetSecondEnvelope(2019);

            // assert
            Assert.AreEqual(4400m, secondEnvelope, "Second envelope was not calculated correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueFinancialEnvelopeCalculator_GetStartYear_ShouldReturnEarliestYearForDeliverablePeriods()
        {
            // arrange
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = GetDeliverablePeriods();

            // act
            int startYear = deliverablePeriods.GetStartYear();

            // assert
            Assert.AreEqual(2018, startYear, "Start year was not determined correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PlannedValueFinancialEnvelopeCalculator_GetEndYear_ShouldReturnLatestYearForDeliverablePeriods()
        {
            // arrange
            IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> deliverablePeriods = GetDeliverablePeriods();

            // act
            int endYear = deliverablePeriods.GetEndYear();

            // assert
            Assert.AreEqual(2019, endYear, "End year was not determined correctly");
        }

        private static IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> GetDeliverablePeriods()
        {
            contractAllocationsContractAllocation corporateAllocation = new contractAllocationsContractAllocation
            {
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = 800m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 9, year = 2018, plannedValue = 900m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 10, year = 2018, plannedValue = 1000m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 11, year = 2018, plannedValue = 1100m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 12, year = 2018, plannedValue = 1200m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2019, plannedValue = 100m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 2, year = 2019, plannedValue = 200m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 3, year = 2019, plannedValue = 300m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = 400m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 5, year = 2019, plannedValue = 500m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 6, year = 2019, plannedValue = 600m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 7, year = 2019, plannedValue = 700m },
                        }
                    },
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 2
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = 800m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 9, year = 2018, plannedValue = 900m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 10, year = 2018, plannedValue = 1000m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 11, year = 2018, plannedValue = 1100m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 12, year = 2018, plannedValue = 1200m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 1, year = 2019, plannedValue = 100m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 2, year = 2019, plannedValue = 200m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 3, year = 2019, plannedValue = 300m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 4, year = 2019, plannedValue = 400m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 5, year = 2019, plannedValue = 500m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 6, year = 2019, plannedValue = 600m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 7, year = 2019, plannedValue = 700m },
                        }
                    }
                }
            };

            return corporateAllocation.contractDeliverables
                .SelectMany(d => d.contractDeliverablePeriods)
                .ToList();
        }
        private static IEnumerable<contractDeliverablePeriodsTypeContractDeliverablePeriod> GetDeliverablePeriodsShort()
        {
            contractAllocationsContractAllocation corporateAllocation = new contractAllocationsContractAllocation
            {
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 1
                        },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 8, year = 2018, plannedValue = 800m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 9, year = 2018, plannedValue = 900m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 10, year = 2018, plannedValue = 1000m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 11, year = 2018, plannedValue = 1100m },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { period = 12, year = 2018, plannedValue = 1200m }
                        }
                    },
                }
            };

            return corporateAllocation.contractDeliverables
                .SelectMany(d => d.contractDeliverablePeriods)
                .ToList();
        }
    }
}
