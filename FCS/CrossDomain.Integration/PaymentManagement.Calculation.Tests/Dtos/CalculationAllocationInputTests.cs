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
