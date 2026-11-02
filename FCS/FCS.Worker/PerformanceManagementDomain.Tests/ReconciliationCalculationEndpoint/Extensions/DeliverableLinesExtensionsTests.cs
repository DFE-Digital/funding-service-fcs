namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Extensions
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;

    [TestClass]
    public class DeliverableLinesExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableLinesExtensions_GetSumOfParentDeliverablePlannedValue_ShouldCalculateWhenThereAre2ChildGroups()
        {
            // arrange
            const decimal parent1Value = 18271;
            const decimal parent2Value = 24079;

            List<DeliverableLine> deliverableLines = new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 5
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 2
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 3
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 4
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 6
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 7
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 8
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 9
                }
            };

            // act
            decimal parentDeliverablePlannedValue = deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(new List<DeliverableCodeInfo>
            {
                new DeliverableCodeInfo(1, null, "CRDGC", false),
                new DeliverableCodeInfo(2, 1, "CRDSC", false),
                new DeliverableCodeInfo(3, 2),
                new DeliverableCodeInfo(4, 2),
                new DeliverableCodeInfo(5, 1),
                new DeliverableCodeInfo(6, 2),
                new DeliverableCodeInfo(7, 2),
                new DeliverableCodeInfo(8, 2),
                new DeliverableCodeInfo(9, 2),

            });

            // assert
            Assert.AreEqual(parent2Value + parent1Value, parentDeliverablePlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableLinesExtensions_GetSumOfParentDeliverablePlannedValue_ShouldCalculateWhenThereAre1ChildGroup()
        {
            // arrange
            const decimal parent1Value = 18271;

            List<DeliverableLine> deliverableLines = new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 3
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 4
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 6
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 7
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 8
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 8
                }
            };

            // act
            decimal parentDeliverablePlannedValue = deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(new List<DeliverableCodeInfo>
            {
                new DeliverableCodeInfo(1, null),
                new DeliverableCodeInfo(2, 1),
                new DeliverableCodeInfo(3, 2),
                new DeliverableCodeInfo(4, 2),
                new DeliverableCodeInfo(5, 1),
                new DeliverableCodeInfo(6, 2),
                new DeliverableCodeInfo(7, 2),
                new DeliverableCodeInfo(8, 2),
                new DeliverableCodeInfo(9, 2),

            });

            // assert
            Assert.AreEqual(parent1Value, parentDeliverablePlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableLinesExtensions_GetSumOfParentDeliverablePlannedValue_ShouldCalculateWhenThereIsOneDeliverable()
        {
            // arrange
            const decimal parent1Value = 18271;

            List<DeliverableLine> deliverableLines = new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 5
                },
            };

            // act
            decimal parentDeliverablePlannedValue = deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(new List<DeliverableCodeInfo>
            {
                new DeliverableCodeInfo(5, 1, "AEBC-ASCL2021_CL", true),
            });

            // assert
            Assert.AreEqual(parent1Value, parentDeliverablePlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableLinesExtensions_GetSumOfParentDeliverablePlannedValue_ShouldCalculateWhenThereIsOnDeliverable2()
        {
            // arrange
            const decimal parent1Value = 1000;
            const decimal parent2Value = 2000;
            const string claimRecGroupCode = "some code";

            List<DeliverableLine> deliverableLines = new List<DeliverableLine>
            {
                new DeliverableLine
                {
                    ParentPlannedValue = parent1Value,
                    DeliverableCode = 2
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 3
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 4
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 6
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 7
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 8
                },
                new DeliverableLine
                {
                    ParentPlannedValue = parent2Value,
                    DeliverableCode = 9
                }
            };

            // act
            decimal parentDeliverablePlannedValue = deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(new List<DeliverableCodeInfo>
            {
                new DeliverableCodeInfo(1, null),
                new DeliverableCodeInfo(2, 1, allowProfile:true, claimReconciliationDeliverableGroupCode:claimRecGroupCode),
                new DeliverableCodeInfo(3, 2, claimRecGroupCode),
                new DeliverableCodeInfo(4, 2, claimRecGroupCode),
                new DeliverableCodeInfo(5, 1, allowProfile:true, claimReconciliationDeliverableGroupCode:"other"),
                new DeliverableCodeInfo(6, 2, claimRecGroupCode),
                new DeliverableCodeInfo(7, 2, claimRecGroupCode),
                new DeliverableCodeInfo(8, 2, claimRecGroupCode),
                new DeliverableCodeInfo(9, 2, claimRecGroupCode),
              
            });

            // assert
            Assert.AreEqual(parent1Value + parent2Value, parentDeliverablePlannedValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DeliverableLinesExtensions_GetSumOfParentDeliverablePlannedValue_ShouldReturnZeroWhenWhenDeliverableLinesAreEmpty()
        {
            // arrange
            
            List<DeliverableLine> deliverableLines = new List<DeliverableLine>();

            // act
            decimal parentDeliverablePlannedValue = deliverableLines.GetSumOfParentDeliverablesPlannedValueForGroup(new List<DeliverableCodeInfo>
            {
                new DeliverableCodeInfo(1, null),
                new DeliverableCodeInfo(2, 14),
                new DeliverableCodeInfo(3, 14),
                new DeliverableCodeInfo(4, 14),
                new DeliverableCodeInfo(5, 14),
                new DeliverableCodeInfo(6, 14),
                new DeliverableCodeInfo(7, 14),
                new DeliverableCodeInfo(8, 14),
                new DeliverableCodeInfo(9, 14),
                new DeliverableCodeInfo(10, 14),
                new DeliverableCodeInfo(13, 1),
                new DeliverableCodeInfo(14, 1, allowProfile:false),
            });

            // assert
            parentDeliverablePlannedValue.Should().Be(0);
        }
    }
}
