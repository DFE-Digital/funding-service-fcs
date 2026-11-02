namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class OverDeliveryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldCapWhenOverDeliveryWithNoTolerance_R07()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 8010} // 8080
                }),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 2005} // 2020
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            const int currentPeriod = 202102;

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 02, 2021));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == currentPeriod);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == currentPeriod);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == currentPeriod);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");

            Assert.AreEqual(-80m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-20m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldNotCapWhenOverDeliveryWithTolerance_R08()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0), 
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 8010}, // 8080
                }),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 5},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 0}, 
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 2005} // 2020
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            input.SetOverDeliveryForPeriod(2021, 10);
            Period period = new Period(202103);

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, period.Month, period.Year));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == period);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == period);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == period);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");

            Assert.AreEqual(0m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(0m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FinancialYearAllocationLevelBehaviour_ShouldCapWhenOverDeliveryWithToleranceExceeded_R09()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 5000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 8000, plannedVolume: 0)
                }, allowProfile:true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 10730}, // 10800 - fp 1
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 6060}, // 6060 - fp 2
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
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 1000}, // 1200 - fp 1
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 2020}  // 2020 - fp 2
                })
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            input.SetOverDeliveryForPeriod(2021, 10);
            Period period = new Period(202104);

            // act
            var calculationResultLines = FinancialYearAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, period.Month, period.Year));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == period);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == period);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == period);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");

            Assert.AreEqual(-960m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-120m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldCapWhenOverDeliveryWithToleranceExceeded_R14()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                // profiled parent
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
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
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 1500, plannedVolume: 0) // total 18000

                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 10730}, // 10800 - fp 1
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 6060}, // 6060 + 10800 = 16800
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 1000}, // 1200 - fp 1
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 2020}  // 2020 + 1200 = 3220
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            input.SetOverDelivery(10);
            Period period = new Period(202109);

            // act
            var calculationResultLines = AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, period.Month, period.Year));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == period);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == period);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == period);
            
            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");
            Assert.AreEqual(-235.10m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-44.90m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
        }
    }
}
