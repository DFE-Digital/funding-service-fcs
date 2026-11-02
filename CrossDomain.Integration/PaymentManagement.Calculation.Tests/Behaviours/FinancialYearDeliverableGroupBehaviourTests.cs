namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FinancialYearDeliverableGroupBehaviourTests
    {
        /// <summary>
        /// These examples are on story - 30325
        /// </summary>
        private static readonly List<CappingGroup> CappingGroups = new List<CappingGroup>
        {
            new CappingGroup(fundingStreamPeriodCappingGroupId: 1, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: false),
            new CappingGroup(fundingStreamPeriodCappingGroupId: 2, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: false),
            new CappingGroup(fundingStreamPeriodCappingGroupId: 3, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: false),
            new CappingGroup(fundingStreamPeriodCappingGroupId: 4, allowUnderDeliveryToBeReUsed: false, allowOverDeliveryToBeOffset: false),
        };

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearDeliverGroupBehaviour_ShouldApportionCap_Example1()
        {
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 3000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 8000 planned value, 10k actual value
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 16000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(7, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 500},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 500},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(8, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 250},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 250},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 16k planned value, 1.5k actual value
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 24000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(9, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 1000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 1000},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(10, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 1000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 24k planned value, 3k actual value
                },allowProfile:false, null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 16000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 16000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4),
                new CalculationDeliverableInput(11, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 1500},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 1500},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) 
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4),
                new CalculationDeliverableInput(12, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 750},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 750},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0) // 32k planned value, 3k actual value
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            const int currentPeriod = 202009;

            // act
            var calculationResultLines = FinancialYearDeliverableGroupBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            var deliverablesWithCap = new List<(int deliverableCode, decimal expectedCappedValue)>
            {
                (5, -1200),
                (6, -800),
            };

            var deliverablesThatAreCappedButShouldnt = calculationResultLines
                .Where(l => l.Period == currentPeriod && !deliverablesWithCap.Select(d => d.deliverableCode).Contains(l.DeliverableCode) && l.CappedPaymentAmount != 0).ToList();

            Assert.IsFalse(deliverablesThatAreCappedButShouldnt.Any(),
                $"the followingDeliverales have capped values that shouldn't: {string.Join(", ", deliverablesThatAreCappedButShouldnt.Select(l => l.DeliverableCode))}");

            deliverablesWithCap.ForEach(d =>
            {
                CalculationResultLine deliverable = calculationResultLines.Single(l => l.DeliverableCode == d.deliverableCode && l.Period == currentPeriod);
                Assert.AreEqual(d.expectedCappedValue, deliverable.CappedPaymentAmount, $"CappedPaymentAmount is not correct for deliverable :{d}");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearDeliverGroupBehaviour_ShouldApportionCap_Example2()
        {
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 12000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 4000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 8000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 600},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),// 16k planned value, 10.7k actual value
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:1),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 30000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(7, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 21000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 8000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(8, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 14000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 2000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),// 38k planned value, 45k actual value
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:2),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 26000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 12000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(9, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 8000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 12000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(10, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 4000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),// 38k planned value, 28k actual value
                },allowProfile:false, null, fundingStreamPeriodCappingGroupId:3),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 40000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 16000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4),
                new CalculationDeliverableInput(11, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 16000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 1000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4),
                new CalculationDeliverableInput(12, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 8000},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 1000},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),// 56k planned value, 26k actual value
                }, allowProfile:false, cappingApportionmentPriorityOrder:null, fundingStreamPeriodCappingGroupId:4)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, CappingGroups);
            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2021-05-09 22:00"), 05, 2021);

            // act
            var calculationResultLines = FinancialYearDeliverableGroupBehaviour.Calculate(input, currentPeriod);

            // assert
            var deliverablesWithCap = new List<(int deliverableCode, decimal expectedCappedValue)>
            {
                (7, -4600),
                (8, -2400),
                (9, -3000),
                (10, -1000)
            };

            var deliverablesThatAreCappedButShouldnt = calculationResultLines
                .Where(l => l.Period == currentPeriod.CalendarPeriod && !deliverablesWithCap.Select(d => d.deliverableCode).Contains(l.DeliverableCode) && l.CappedPaymentAmount != 0).ToList();

            Assert.IsFalse(deliverablesThatAreCappedButShouldnt.Any(),
                $"the followingDeliverales have capped values that shouldn't: {string.Join(", ", deliverablesThatAreCappedButShouldnt.Select(l => l.DeliverableCode))}");

            deliverablesWithCap.ForEach(d =>
            {
                CalculationResultLine deliverable = calculationResultLines.Single(l => l.DeliverableCode == d.deliverableCode && l.Period == currentPeriod.GetPeriod());
                Assert.AreEqual(d.expectedCappedValue, deliverable.CappedPaymentAmount, $"CappedPaymentAmount is not correct for deliverable :{d}");
            });
        }
    }
}
