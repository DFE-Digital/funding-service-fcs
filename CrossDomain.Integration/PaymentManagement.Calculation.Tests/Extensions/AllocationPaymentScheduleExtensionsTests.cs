namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;

    [TestClass]
    public class AllocationPaymentScheduleExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationPaymentScheduleExtensions_ShouldEnrichWithPlannedValues()
        {
            // arrange
            CalculationAllocationInput calculationAllocationInput = new CalculationAllocationInput(
                "AAC-1013",
                1,
                "FSP",
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 100, plannedVolume:101),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 200, plannedVolume:201),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 300, plannedVolume:301),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 400, plannedVolume:401),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, plannedValue: 500, plannedVolume:501),
                        new CalculationDeliverablePeriodInput(202002, plannedValue: 600, plannedVolume:601),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                },
                "ukprn",
                "orgId",
                "cn1", 
                new List<CappingGroup>());

            Allocation allocation = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "202001",
                            },
                            new ScheduledPayment
                            {
                                Period = "202002",
                            },
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "202001",
                            },
                            new ScheduledPayment
                            {
                                Period = "202002",
                            },
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 3,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment
                            {
                                Period = "202001",
                            },
                            new ScheduledPayment
                            {
                                Period = "202002",
                            },
                        }
                    }
                }
            };

            // act
            allocation.EnrichWithPlannedValues(calculationAllocationInput);

            // assert
            calculationAllocationInput.Deliverables.ToList()
                .ForEach(d =>
                {
                    var psDeliverable =
                        allocation.AllocationDeliverables.Single(dPs => dPs.DeliverableCode == d.DeliverableCode);
                    d.DeliverablePeriods.ToList()
                        .ForEach(inputDp =>
                        {
                            var psDeliverablePeriod =
                                psDeliverable.ScheduledPayments.Single(sp => sp.Period == inputDp.Period.ToString());
                            Assert.AreEqual(inputDp.PlannedValue, psDeliverablePeriod.PlannedValue, $"The planned value for period: {inputDp.Period} and code:{d.DeliverableCode}");
                            Assert.AreEqual(inputDp.PlannedVolume, psDeliverablePeriod.PlannedVolume, $"The planned volume for period: {inputDp.Period} and code:{d.DeliverableCode}");
                        });
                });
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationExtensions_ShouldEnrichWithActualValues()
        {
            // arrange
            Allocation paymentSchedule = new Allocation
            {
                AllocationDeliverables = new List<AllocationDeliverable>
                {
                    new AllocationDeliverable
                    {
                        DeliverableCode = 1,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment { Period = "202001" },
                            new ScheduledPayment { Period = "202002" }
                        }
                    },
                    new AllocationDeliverable
                    {
                        DeliverableCode = 2,
                        ScheduledPayments = new List<ScheduledPayment>
                        {
                            new ScheduledPayment { Period = "202001" },
                            new ScheduledPayment { Period = "202002" }
                        }
                    }
                }
            };

            CalculationAllocationInput calculationAllocationInput = new CalculationAllocationInput(
                "ESF-1234",
                1,
                "EFS1420",
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, actualVolume: 10, actualValue: 100),
                        new CalculationDeliverablePeriodInput(202002, actualVolume: 20, actualValue: 200),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(202001, actualVolume: 0, actualValue: 10),
                        new CalculationDeliverablePeriodInput(202002, actualVolume: 0, actualValue: 20),
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                },
                "12345",
                "ORG0012345",
                "ESIF-1234", 
                new List<CappingGroup>());

            // act
            paymentSchedule.EnrichWithActualValues(calculationAllocationInput);

            // assert
            ScheduledPayment deliverable1Period202001 = paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.Single(sp => sp.Period == "202001");
            ScheduledPayment deliverable1Period202002 = paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 1).ScheduledPayments.Single(sp => sp.Period == "202002");
            ScheduledPayment deliverable2Period202001 = paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2).ScheduledPayments.Single(sp => sp.Period == "202001");
            ScheduledPayment deliverable2Period202002 = paymentSchedule.AllocationDeliverables.Single(ad => ad.DeliverableCode == 2).ScheduledPayments.Single(sp => sp.Period == "202002");

            Assert.AreEqual(10, deliverable1Period202001.ActualVolume, "Actual Volume not enriched correctly");
            Assert.AreEqual(100m, deliverable1Period202001.ActualValue, "Actual Value not enriched correctly");

            Assert.AreEqual(20, deliverable1Period202002.ActualVolume, "Actual Volume not enriched correctly");
            Assert.AreEqual(200m, deliverable1Period202002.ActualValue, "Actual Value not enriched correctly");

            Assert.AreEqual(0, deliverable2Period202001.ActualVolume, "Actual Volume not enriched correctly");
            Assert.AreEqual(10m, deliverable2Period202001.ActualValue, "Actual Value not enriched correctly");

            Assert.AreEqual(0, deliverable2Period202002.ActualVolume, "Actual Volume not enriched correctly");
            Assert.AreEqual(20m, deliverable2Period202002.ActualValue, "Actual Value not enriched correctly");
        }
    }
}
