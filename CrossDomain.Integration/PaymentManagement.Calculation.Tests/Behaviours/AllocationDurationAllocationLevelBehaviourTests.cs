namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllocationDurationAllocationLevelBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldCalculateReconciliationPayment()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {NetPayment = 100, ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0) {ActualValue = 100}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {NetPayment = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0),
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
           
            var calculatedDeliverablePeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202009);
            Assert.AreEqual(100, calculatedDeliverablePeriod.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount is not right for code 1 and period 202009");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldCalculateCappingPayment()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {NetPayment = 100, ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0) {NetPayment = 50, ActualValue = 100, }
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {NetPayment = 50, ActualValue = 200},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0) {NetPayment = 50, ActualValue = 200},
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0)
                }, allowProfile: false, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert

            var calculatedDeliverablePeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202009);
            // AV / TAV x TCP
            Assert.AreEqual(Math.Round((decimal)200/600 * (400 - 600), 2), calculatedDeliverablePeriod.CappedPaymentAmount, $"The ReconciliationPaymentAmount is not right for code 1 and period 202009");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldNotRecalculateReconciliationAndCappingPaymentsForPreviousPeriods()
        {
            // arrange
            var randomBeforeCappedPaymentValue = -123456.78m;

            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0)
                    {
                        NetPayment = 100m,
                        ActualValue = 105m, /* restated actual value increased by 5 */
                        ReconciliationPayment = 100m,
                        CappedPayment = randomBeforeCappedPaymentValue
                    },
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 50, plannedVolume: 0)
                    {
                        ActualValue = 100m,
                        CappedPayment = null
                    }
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine previousPeriod = calculationResultLines.Single(l => l.Period == 202008);
            Assert.AreEqual(100m, previousPeriod.ReconciliationPaymentAmount, "Reconciliation Payment for previous period was recalculated");
            Assert.AreEqual(randomBeforeCappedPaymentValue, previousPeriod.CappedPaymentAmount, "Capped Payment Amount for previous period was recalculated");

            CalculationResultLine currentPeriod = calculationResultLines.Single(l => l.Period == 202009);
            Assert.AreEqual(105m, currentPeriod.ReconciliationPaymentAmount, "Reconciliation Payment for current period was not calculated");
            Assert.AreNotEqual(null, currentPeriod.CappedPaymentAmount, "Capped Payment Amount for current period was not calculated");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldCreatePostYearEndPeriod()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 10, 2020));

            // assert
            inputDeliverables.Select(d => d.DeliverableCode).ToList().ForEach(d =>
            {
                var numPeriods = calculationResultLines.Count(l => l.DeliverableCode == d);
                Assert.AreEqual(3, numPeriods);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldNotCreatePeriodBeforeYearStarts()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 7, 2020));

            // assert
            inputDeliverables.Select(d => d.DeliverableCode).ToList().ForEach(d =>
            {
                var numPeriods = calculationResultLines.Count(l => l.DeliverableCode == d);
                Assert.AreEqual(2, numPeriods);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldApportionCapAcrossDeliverablesWithActuals()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                // profiled parent
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 60, NetPayment = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 90}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 80, NetPayment = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 110}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child with zero actuals
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 0, NetPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 0}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var calculationResultLines = AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202009);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202009);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202009);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202009);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");
            // Apportioned cap = TAV for Deliverable Line / TAV x TCP
            Assert.AreEqual(-61.76m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-78.24m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(0m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldApportionPositiveCapWhenActualValueIsNegative()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                // profiled parent
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 50, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue:50, plannedVolume: 0)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 50}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 50}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = -100}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var calculationResultLines = AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            CalculationResultLine deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202009);
            CalculationResultLine deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202009);
            CalculationResultLine deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202009);
            CalculationResultLine deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202009);

            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount has been set for non-payable parent deliverable 1");
            // Apportioned cap = TAV for Deliverable Line / TAV x TCP
            // 
            Assert.AreEqual(-75m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(-50m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(25m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDurationAllocationLevelBehaviour_ShouldApportionZeroWhenOverallCapIsPositive()
        {
            // arrange
            var inputDeliverables = new List<CalculationDeliverableInput>
            {
                // profiled parent
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 50, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue:50, plannedVolume: 0)
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 50}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                // payable child
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = 50}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0) {ActualValue = -500},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0) {ActualValue = -100}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null)
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());

            // act
            var calculationResultLines = AllocationDurationAllocationLevelBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020));

            // assert
            var deliverable1 = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202009);
            var deliverable2 = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202009);
            var deliverable3 = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202009);
            var deliverable4 = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202009);

            // TPV = Total Planned Value = 100. TAV = Total Actual Value = -350
            // Total cap = MIN(0, (TPV-TAV))
            // Total cap = MIN(0, (100-(-350)))
            // Total cap = MIN(0, 450) = 0 
            Assert.AreEqual(0m, deliverable1.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 1");
            Assert.AreEqual(0m, deliverable2.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 2");
            Assert.AreEqual(0m, deliverable3.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 3");
            Assert.AreEqual(0m, deliverable4.CappedPaymentAmount, "CappedPaymentAmount is not correct for payable deliverable 4");
        }
    }
}
