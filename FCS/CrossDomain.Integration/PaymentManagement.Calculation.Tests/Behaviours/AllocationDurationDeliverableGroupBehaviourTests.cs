namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllocationDurationDeliverableGroupBehaviourTests
    {
        private static readonly List<CappingGroup> CappingGroups = new List<CappingGroup>
        {
            new CappingGroup(fundingStreamPeriodCappingGroupId: 1, allowUnderDeliveryToBeReUsed: true, allowOverDeliveryToBeOffset: false),
            new CappingGroup(fundingStreamPeriodCappingGroupId: 2, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: true),
            new CappingGroup(fundingStreamPeriodCappingGroupId: 3, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: false),
        };

        [TestMethod, TestCategory("UnitTest")] // example 1
        public void AllocationDurationDeliverableGroupBehaviour_ShouldWorkWithNoOverDelivery()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 100 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 500},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 3500 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 200 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");

            Assert.AreEqual(0, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            Assert.AreEqual(0, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            Assert.AreEqual(0, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 2
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapOverDeliveryWhenOffsetNotAllowed()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 6000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 6100 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 150},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 150 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 450},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 450 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 6100/6100 * -100
            Assert.AreEqual(-100, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            Assert.AreEqual(0, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            Assert.AreEqual(0, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 3
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapBothWhenBothOverDeliver()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 200},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 6000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 6200 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 8000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 4000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 6200/6200 * -200
            Assert.AreEqual(-200, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 8000/1200 * -3000
            Assert.AreEqual(-2000, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            Assert.AreEqual(-1000, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 4
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapCorrectlyWithPartialOverDeliveryAndOffset()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 300},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 3300 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 8000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 4000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 3300/3300 * 0
            Assert.AreEqual(-0, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 8000/1200 * -300
            Assert.AreEqual(-200, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            Assert.AreEqual(-100, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 5
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapCorrectlyWithPartialOverDeliveryAndOffsetAndOneDeliverableHavingZeroActuals()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 300},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 3300 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 0 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 6000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 6000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 12000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 3300/3300 * 0
            Assert.AreEqual(0, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            Assert.AreEqual(0, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 12000/12000 * -300
            Assert.AreEqual(-300, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 6
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapCorrectlyWithFullOverDeliveryAndOffsetApplied()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 300},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 3300 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 3300},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = 3300},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, 6600 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 700},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 2700 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 3300/3300 * 0
            Assert.AreEqual(0, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            Assert.AreEqual(0, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 6600/12600 * -0
            Assert.AreEqual(-0, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")] // example 7
        public void AllocationDurationDeliverableGroupBehaviour_ShouldCapCorrectlyWithNegativeActualsAndPositiveCap()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 500},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 5000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 5500 actual value
                }, allowProfile:true, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1500, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1500, plannedVolume: 0){ActualValue = -1000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 3000 planned value, -1000 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 3000, plannedVolume: 0){ActualValue = 5000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 3000, plannedVolume: 0){ActualValue = 6000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 6000 planned value, 1100 actual value
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0, 0
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:3)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = AllocationDurationDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 1");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 5500/5500 * 0
            Assert.AreEqual(0, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 2");
            Assert.AreEqual(0, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 3");
            //(AV / CGAV) x (Group Adjusted Capping Payment) -1000/10000 * -500
            Assert.AreEqual(50, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 4");
            //(AV / CGAV) x (Group Adjusted Capping Payment) 11000/10000 * -500
            Assert.AreEqual(-550, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for deliverable 6");
        }
    }
}
