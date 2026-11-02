namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class FinancialYearAllocationLevelBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldCalculateCappingForApril()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 9800} // 10000
                }),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 3800} // 4000
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 800} // 1000
                }),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 4800} // 5000
                }),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0} // 0
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            const int currentPeriod = 202103;

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 03, 2021));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");
            
            Assert.AreEqual(-2000m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-800m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(-200m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
            Assert.AreEqual(-1000m, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldCalculateCappingForMay()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 2000, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 9800},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 1000}, // 1000
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 3800}, // 4000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 200},  // 200
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 800}, // 1000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 75},  // 75
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 4800}, // 5000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 500},  // 500
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 1600, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 1600, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 0}, // 0
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 0}, // 0
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            const int currentPeriod = 202104;

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 04, 2021));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");

            Assert.AreEqual(-2000m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-800m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(-200m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
            Assert.AreEqual(-1000m, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 5");
            Assert.AreEqual(0m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 6");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldCalculateCappingForJune()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 2000, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 550},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 9800}, // total 1st FP 10500
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 1000}, 
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 4400}, // total 2nd FP 5400
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 3800}, // total 1st FP 4000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 200}, 
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 575}, // total 2nd FP 775
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 800}, // total 1st FP 1000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 75},  // total for 2nd FP 75
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0),
                }),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 4800}, // total for 1st FP 5000
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 500},  
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 1400}, // total for 2nd FP 1900
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0)
                }),
                new CalculationDeliverableInput(6, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 200},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 300}, // total for 1st FP 500
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 0}, 
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 250}, // total for 1nd FP 250
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0)
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            const int currentPeriod = 202105;

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 05, 2021));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == currentPeriod);
            CalculationResultLine deliverable5 = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == currentPeriod);
            CalculationResultLine deliverable6 = calculationResultLines.Single(l => l.DeliverableCode == 6 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");

            Assert.AreEqual(-2757.14m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-989.28m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(-241.67m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
            Assert.AreEqual(-1280.96m, deliverable5.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 5");
            Assert.AreEqual(-130.95m, deliverable6.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 6");
        }
    }
}
