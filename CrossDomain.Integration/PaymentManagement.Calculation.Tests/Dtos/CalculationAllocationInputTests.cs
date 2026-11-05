namespace PaymentManagement.Calculation.Tests.Dtos
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CalculationAllocationInputTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInput_MergePaymentValuesNotIncludingActualsOntoInput_ShouldAddDeliverableThatHavePlannedValuesWhenNotPresent()
        {
            // arrange
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 0, string.Empty,
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period:202001, plannedValue:10, plannedVolume:0),
                    }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                }, 
                string.Empty,
                string.Empty,
                string.Empty,
                new List<CappingGroup>());

            List<DeliverablePeriodPaymentInfo> deliverablePeriodPaymentInfos = new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202001, 1, 0, 10, 11, 1, 2, null, null),
                new DeliverablePeriodPaymentInfo(202002, 1, 0, 10, 11, 1, 2, null, null)
            };

            var fspDeliverableInfos = new List<FspDeliverableInfo>()
            {
                new FspDeliverableInfo(1, true, 11, 111),
                new FspDeliverableInfo(2, true, 22, 222)
            };

            // act
            input.MergePaymentValuesNotIncludingActualsOntoInput(deliverablePeriodPaymentInfos, fspDeliverableInfos);

            // assert
            Assert.IsTrue(input.Deliverables.Any(d => d.DeliverableCode == 1), "The planned value deliverable has not been added");
            var deliverableOne = input.Deliverables.Single(d => d.DeliverableCode == 1);

            Assert.AreEqual(2, deliverableOne.DeliverablePeriods.Count, "The number of deliverable periods added is wrong");
            Assert.AreEqual(10, deliverableOne.DeliverablePeriods.Single(dp => dp.Period == 202001).PlannedValue, "The planned value is not correct");

            Assert.IsTrue(deliverableOne.AllowProfile, "The AllowProfile is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInput_MergePaymentValuesIncludingActualsOntoInput_ShouldUpdateAndAddPeriodsForKnownDeliverables()
        {
            var existingPeriod = new CalculationDeliverablePeriodInput(202001, plannedValue: 10, plannedVolume: 2);
            var input = new CalculationAllocationInput(string.Empty, 0, string.Empty,
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput> { existingPeriod })
                },
                string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            input.MergePaymentValuesIncludingActualsOntoInput(new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202001, 1, 11, 12, 3, 4, 5, 6, 7, 8, 9),
                new DeliverablePeriodPaymentInfo(202002, 1, 21, 22, 4, 5, 6, 7, 8, 9, 10),
                new DeliverablePeriodPaymentInfo(202001, 2, 0, 0, 0, 0, 0, 0, 0)
            });

            Assert.AreEqual(2, input.Deliverables.Single().DeliverablePeriods.Count);
            Assert.AreEqual(7m, existingPeriod.ActualValue);
            Assert.AreEqual(6, existingPeriod.ActualVolume);
            Assert.AreEqual(11m, existingPeriod.NetPayment);
            Assert.AreEqual(5m, existingPeriod.ReconciliationPayment);
            Assert.AreEqual(4m, existingPeriod.CappedPayment);
            Assert.AreEqual(8m, existingPeriod.BalancingPayment);
            Assert.AreEqual(9m, existingPeriod.ProfilePayment);

            var addedPeriod = input.Deliverables.Single().DeliverablePeriods.Single(period => period.Period == 202002);
            Assert.AreEqual(22m, addedPeriod.PlannedValue);
            Assert.AreEqual(4, addedPeriod.PlannedVolume);
            Assert.AreEqual(8m, addedPeriod.ActualValue);
            Assert.AreEqual(7, addedPeriod.ActualVolume);
            Assert.AreEqual(21m, addedPeriod.NetPayment);
            Assert.AreEqual(6m, addedPeriod.ReconciliationPayment);
            Assert.AreEqual(5m, addedPeriod.CappedPayment);
            Assert.AreEqual(9m, addedPeriod.BalancingPayment);
            Assert.AreEqual(10m, addedPeriod.ProfilePayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInput_MergePaymentValuesNotIncludingActualsOntoInput_ShouldOnlyAddProfileDeliverablesWithPlannedValues()
        {
            var existingPeriod = new CalculationDeliverablePeriodInput(202001, plannedValue: 10, plannedVolume: 2);
            var input = new CalculationAllocationInput(string.Empty, 0, string.Empty,
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput> { existingPeriod })
                },
                string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            input.MergePaymentValuesNotIncludingActualsOntoInput(new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202001, 1, 11, 12, 3, 4, 5, null, null),
                new DeliverablePeriodPaymentInfo(202002, 2, 21, 22, 4, 5, 6, null, null),
                new DeliverablePeriodPaymentInfo(202003, 3, 0, null, null, 0, 0, null, null)
            }, new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(2, true, 7, 8),
                new FspDeliverableInfo(3, false, 9, 10)
            });

            Assert.AreEqual(2, input.Deliverables.Count);
            Assert.AreEqual(12m, existingPeriod.PlannedValue);
            Assert.AreEqual(3, existingPeriod.PlannedVolume);
            Assert.AreEqual(11m, existingPeriod.NetPayment);
            Assert.AreEqual(5m, existingPeriod.ReconciliationPayment);
            Assert.AreEqual(4m, existingPeriod.CappedPayment);

            var addedDeliverable = input.Deliverables.Single(deliverable => deliverable.DeliverableCode == 2);
            Assert.IsTrue(addedDeliverable.AllowProfile);
            Assert.AreEqual(8, addedDeliverable.FundingStreamPeriodCappingGroupId);
            Assert.AreEqual(1, addedDeliverable.DeliverablePeriods.Count);
            Assert.AreEqual(22m, addedDeliverable.DeliverablePeriods.Single().PlannedValue);
            Assert.AreEqual(4, addedDeliverable.DeliverablePeriods.Single().PlannedVolume);
            Assert.AreEqual(21m, addedDeliverable.DeliverablePeriods.Single().NetPayment);
            Assert.IsFalse(input.Deliverables.Any(deliverable => deliverable.DeliverableCode == 3));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInput_SetOverDelivery_ShouldShouldSetOverDeliveryForFinancialsYearsWhenThereIsMoreThanOne()
        {
            // arrange
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 0, string.Empty,
                new List<CalculationDeliverableInput>
                {
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 1500, plannedVolume: 0) 
                    }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0){ActualValue = 10}
                    }, allowProfile : false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                },
                string.Empty,
                string.Empty,
                string.Empty,
                new List<CappingGroup>());

            List<DeliverablePeriodPaymentInfo> deliverablePeriodPaymentInfos = new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202001, 1, 0, 10, 11, 1, 2, null, null),
                new DeliverablePeriodPaymentInfo(202002, 1, 0, 10, 11, 1, 2, null, null)
            };

            List<CappingPeriod> cappingPeriods = new List<CappingPeriod>
            {
                new CappingPeriod(1, 10),
                new CappingPeriod(2, 3),
            };

            // act
            input.SetOverDelivery(cappingPeriods);

            // assert
            var overDeliveryForFp1 = input.GetOverDeliveryForFinancialPeriod(202008);

            var overDeliveryForFp2 = input.GetOverDeliveryForFinancialPeriod(202104);
            Assert.AreEqual(10, overDeliveryForFp1, "The Over Delivery for fp1 is not correct");
            Assert.AreEqual(3, overDeliveryForFp2, "The Over Delivery for fp2 is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationAllocationInput_SetOverDelivery_ShouldShouldSetOverDeliveryForContractWhenThereIsJustOne()
        {
            // arrange
            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 0, string.Empty,
                new List<CalculationDeliverableInput>
                {
                     new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 1500, plannedVolume: 0),
                        new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 1500, plannedVolume: 0)
                    }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                    new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0){ActualValue = 10}
                    }, allowProfile : false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                },
                string.Empty,
                string.Empty,
                string.Empty,
                new List<CappingGroup>());

            List<DeliverablePeriodPaymentInfo> deliverablePeriodPaymentInfos = new List<DeliverablePeriodPaymentInfo>
            {
                new DeliverablePeriodPaymentInfo(202001, 1, 0, 10, 11, 1, 2, null, null),
                new DeliverablePeriodPaymentInfo(202002, 1, 0, 10, 11, 1, 2, null, null)
            };
            List<CappingPeriod> cappingPeriods = new List<CappingPeriod>
            {
                new CappingPeriod(1, 10),
            };

            // act
            input.SetOverDelivery(cappingPeriods);

            // assert
            var overDeliveryForFp1 = input.GetOverDelivery();

            Assert.AreEqual(10, overDeliveryForFp1, "The Over Delivery for fp1 is not correct");
        }
    }
}
