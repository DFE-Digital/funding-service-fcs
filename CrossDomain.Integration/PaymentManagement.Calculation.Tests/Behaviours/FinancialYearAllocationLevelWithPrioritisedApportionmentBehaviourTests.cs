namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Newtonsoft.Json;

    [TestClass]
    public class FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")] // FY 1 Sheet, Example 1, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupActualsExceedCap_ShouldApportionWholeCapToFirstApportionmentPriorityGroup()
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
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-1000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(7000, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(0, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(3000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 1 Sheet, Example 2, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenCapExceedsFirstApportionmentPriorityGroupActuals_ShouldApportionCapAcrossApportionmentPriorityGroupsInOrder()
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
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 201908);
            Assert.AreEqual(-8000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(0, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 201908);
            Assert.AreEqual(-2000, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(10000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 1 Sheet, Example 3, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupActualsExceedCap_ShouldApportionWholeCapToFirstApportionmentPriorityGroupBetweenConstituentDeliverables()
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
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

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

        [TestMethod, TestCategory("UnitTest")] // FY 1 Sheet, Example 4, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenCapExceedsFirstApportionmentPriorityGroupActuals_ShouldApportionCapAcrossApportionmentPriorityGroupsInOrderBetweenConstituentDeliverables()
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
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

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

        [TestMethod, TestCategory("UnitTest")] // FY 1 Sheet, Example 5, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenFirstApportionmentPriorityGroupHasZeroOrNegativeOverallActuals_ShouldApportionWholeCapToSubsequentApportionmentPriorityGroup()
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
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

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

        [TestMethod, TestCategory("UnitTest")] // FY 2 Sheet, Example 1, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FY2_FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenOneFinancialYearIsCappedAndOneIsNotCapped_ShouldCalculateUsingDistinctCapsAcrossFinancialYears()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 5000, plannedVolume: 0) {ActualValue = 8000, NetPayment = 7000, CappedPayment = -1000},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2500, plannedVolume: 0) {ActualValue = 4000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 5000, plannedVolume: 0) {ActualValue = 3000, NetPayment = 3000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2500, plannedVolume: 0) {ActualValue = 500}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2020-05-08 22:00"), 04, 2020);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202004);
            Assert.AreEqual(-1000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(4000, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202004);
            Assert.AreEqual(0, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(500, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 2 Sheet, Example 2, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenBothFinancialYearsAreCapped_ShouldCalculateUsingDistinctCapsAcrossFinancialYears()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 5000, plannedVolume: 0) {ActualValue = 8000, NetPayment = 7000, CappedPayment = -1000},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 5000, plannedVolume: 0) {ActualValue = 8000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 5000, plannedVolume: 0) {ActualValue = 3000, NetPayment = 3000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 5000, plannedVolume: 0) {ActualValue = 12000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2020-05-08 22:00"), 04, 2020);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202004);
            Assert.AreEqual(-9000, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
            Assert.AreEqual(0, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the first capping apportionment priority group");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202004);
            Assert.AreEqual(-2000, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the second capping apportionment priority group");
            Assert.AreEqual(10000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for the second capping apportionment priority group");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 2 Sheet, Example 3, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FY2_FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenOneFinancialYearIsCappedAndOneIsNotCapped_ShouldCalculateUsingDistinctCapsAcrossFinancialYearsAndApportionBetweenConstiuentDeliverables()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 4000, NetPayment = 3500, CappedPayment = -500},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 3000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3200, NetPayment = 2800, CappedPayment = -400},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 1000}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 800, NetPayment = 700, CappedPayment = -100},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 0}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1000, NetPayment = 1000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 400}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000, NetPayment = 2000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 100}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2020-05-08 22:00"), 04, 2020);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202004);
            Assert.AreEqual(-500, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(3000, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202004);
            Assert.AreEqual(-400, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(1000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202004);
            Assert.AreEqual(-100, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(0, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202004);
            Assert.AreEqual(0, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(400, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 202004);
            Assert.AreEqual(0, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(100, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 2 Sheet, Example 4, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FY2_FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenBothFinancialYearsAreCapped_ShouldCalculateUsingDistinctCapsAcrossFinancialYearsAndApportionBetweenConstiuentDeliverables()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 6000, NetPayment = 5250, CappedPayment = -750}, // 75% of group 1 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2000, plannedVolume: 0) {ActualValue = 4000} // 50% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000, NetPayment = 1750, CappedPayment = -250}, // 25% of group 1 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2400} // 30% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 0, NetPayment = 0, CappedPayment = 0}, // 0% of group 1 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1600} // 20% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1000, NetPayment = 1000, CappedPayment = 0}, // 33% of group 2 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2000, plannedVolume: 0) {ActualValue = 9000} // 75% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000, NetPayment = 2000, CappedPayment = 0}, // 67% of group 2 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3000} // 25% of group 2 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-05-08 22:00"), 04, 2020);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202004);
            Assert.AreEqual(-4750, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(0, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202004);
            Assert.AreEqual(-2650, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(0, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202004);
            Assert.AreEqual(-1600, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(0, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202004);
            Assert.AreEqual(-1500, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(7500, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 202004);
            Assert.AreEqual(-500, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(2500, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }

        [TestMethod, TestCategory("UnitTest")] // FY 2 Sheet, Example 5, Resources/FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_Examples.xlsx
        public void FY2_FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_WhenBothFinancialYearsAreCappedAndSomeHaveNegativeActuals_ShouldCalculateUsingDistinctCapsAcrossFinancialYearsAndApportionBetweenConstiuentDeliverables()
        {
            // arrange
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = -4000, NetPayment = -4000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 7000} // 70% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 2000, NetPayment = 2000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 2000} // 20% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(3, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 1000, NetPayment = 1000, CappedPayment = 0},
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 1000} // 10% of group 1 actuals
                }, allowProfile : true, cappingApportionmentPriorityOrder: 1, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(4, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 12000, NetPayment = 8800, CappedPayment = -3200}, // 80% of group 2 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 0}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(5, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202003, plannedValue: 2000, plannedVolume: 0) {ActualValue = 3000, NetPayment = 2200, CappedPayment = -800}, // 20% of group 2 actuals
                    new CalculationDeliverablePeriodInput(period: 202004, plannedValue: 1000, plannedVolume: 0) {ActualValue = 0}
                }, allowProfile : true, cappingApportionmentPriorityOrder: 2, fundingStreamPeriodCappingGroupId: null),
            };

            CalculationAllocationInput allocationInput =
                new CalculationAllocationInput("APPS-1234", 1, "APPS1920", inputDeliverables, "123456", "ORG123456", "EDSK-1234", new List<CappingGroup>());

            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.Parse("2019-05-08 22:00"), 04, 2020);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 1 && l.Period == 202004);
            Assert.AreEqual(-3500, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for Deliverable 1");
            Assert.AreEqual(3500, deliverable1CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 1");

            CalculationResultLine deliverable2CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 2 && l.Period == 202004);
            Assert.AreEqual(-1000, deliverable2CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 2");
            Assert.AreEqual(1000, deliverable2CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 2");

            CalculationResultLine deliverable3CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 3 && l.Period == 202004);
            Assert.AreEqual(-500, deliverable3CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 3");
            Assert.AreEqual(500, deliverable3CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 3");

            CalculationResultLine deliverable4CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 4 && l.Period == 202004);
            Assert.AreEqual(-3200, deliverable4CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 4");
            Assert.AreEqual(0, deliverable4CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 4");

            CalculationResultLine deliverable5CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 5 && l.Period == 202004);
            Assert.AreEqual(-800, deliverable5CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the Deliverable 5");
            Assert.AreEqual(0, deliverable5CalculatedPeriod.NetPaymentAmount, "The NetPaymentAmount is incorrect for Deliverable 5");
        }

        [TestMethod, TestCategory("UnitTest")] // Specflow_D082APPS1920_FYAndAlloc_LevelWithPrioritisation
        public void FY2_FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour_ShouldCalculateCapNoBiggerThanActualsInGroup()
        {
            // arrange
            CalculationAllocationInput allocationInput = GetAllocationInputFromFile();
            
            CensusPeriodInfo currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 09, 2019);

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour.Calculate(allocationInput, currentPeriod);

            // assert
            CalculationResultLine deliverable1CalculatedPeriod = calculationResultLines.Single(l => l.DeliverableCode == 7 && l.Period == 201909);
            Assert.AreEqual(-400, deliverable1CalculatedPeriod.CappedPaymentAmount, "The CappedPaymentAmount is incorrect for the first capping apportionment priority group");
        }

        private static CalculationAllocationInput GetAllocationInputFromFile()
        {
            return FromJson<CalculationAllocationInput>("PaymentManagement.Calculation.Tests",
                "Resources.allocationInput.json");
        }

        public static T FromJson<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<T>(streamReader.ReadToEnd());
            }
        }
    }
}
