namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")] // Example 1, Resources/AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupActualsExceedCap_ShouldApportionWholeCapToFirstApportionmentPriorityGroup()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 5000, plannedVolume: 0) {ActualValue = 8000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 5000, plannedVolume: 0) {ActualValue = 3000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-09-09 22:00"), 08, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-1000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(7000, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(0, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(3000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // Example 2, Resources/AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_WhenCapExceedsFirstApportionmentPriorityGroupActuals_ShouldApportionCapAcrossApportionmentPriorityGroupsInOrder()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 5000, plannedVolume: 0) {ActualValue = 8000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 5000, plannedVolume: 0) {ActualValue = 12000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-09-09 22:00"), 08, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-8000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(0, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(-2000, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(10000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // Example 3, Resources/AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupActualsExceedCap_ShouldApportionWholeCapToFirstApportionmentPriorityGroupBetweenConstituentDeliverables()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 4000} // 50% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3200} // 40% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 800} // 10% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-09-09 22:00"), 08, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-500, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(3500, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(-400, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(2800, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 201908);
            Assert.AreEqual(-100, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(700, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 201908);
            Assert.AreEqual(0, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(1000, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 201908);
            Assert.AreEqual(0, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(2000, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }

        [TestMethod, TestCategory("UnitTest")] // Example 4, Resources/AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_WhenCapExceedsFirstApportionmentPriorityGroupActuals_ShouldApportionCapAcrossApportionmentPriorityGroupsInOrderBetweenConstituentDeliverables()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 6000} // 75% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000} // 25% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 0} // 0% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 9000} // 75% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3000} // 25% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-09-09 22:00"), 08, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-6000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(0, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(-2000, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(0, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 201908);
            Assert.AreEqual(0, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(0, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 201908);
            Assert.AreEqual(-1500, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(7500, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 201908);
            Assert.AreEqual(-500, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(2500, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }

        [TestMethod, TestCategory("UnitTest")] // Example 5, Resources/AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupHasZeroOrNegativeOverallActuals_ShouldApportionWholeCapToSubsequentApportionmentPriorityGroup()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = -4000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 12000} // 80% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201908, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3000} // 20% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-09-09 22:00"), 08, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(0, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(-4000, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(0, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(2000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 201908);
            Assert.AreEqual(0, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(1000, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 201908);
            Assert.AreEqual(-3200, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(8800, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 201908);
            Assert.AreEqual(-800, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(2200, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }
    }
}
