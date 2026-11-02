namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PayOnProfileFundingClaimReconciliationPublishedBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PayOnProfileFundingClaimReconciliationPublishedBehaviour_ShouldCreateNewPeriodAndApportionReconciliationPayment()
        {
            // arrange
            const decimal fcrAllocationReconciliationValue = 50m;

            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {ProfilePayment = 100, BalancingPayment = 1m, ReconciliationPayment = null}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null,allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 200, plannedVolume: 0) {ProfilePayment = 200, BalancingPayment = 2m, ReconciliationPayment = null}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(
                "ALLOC-1", 1, "FSP", inputDeliverables, "12345678", "ORG12345678", "CONTRACT-1", new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileFundingClaimReconciliationPublishedBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020), fcrAllocationReconciliationValue);

            // assert
            CalculationResultLine deliverable1PreviousPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 1 && dp.Period == 202008);
            deliverable1PreviousPeriod.Should().NotBeNull("a previous period should be carried forward for deliverable 1");
            deliverable1PreviousPeriod.ProfileValue.Should().Be(100m, "profile payment should be carried forward for the previous period");
            deliverable1PreviousPeriod.BalancingPaymentAmount.Should().Be(1m, "balancing payment should be carried forward for the previous period");
            deliverable1PreviousPeriod.CappedPaymentAmount.Should().Be(0m, "capping payment should be carried forward for the previous period");
            deliverable1PreviousPeriod.ReconciliationPaymentAmount.Should().BeNull("reconciliation payment should be carried forward for the previous period");

            CalculationResultLine deliverable1CurrentPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 1 && dp.Period == 202009);
            deliverable1CurrentPeriod.Should().NotBeNull("a new period should be created for deliverable 1");
            deliverable1CurrentPeriod.ProfileValue.Should().Be(0m, "profile payment should be zero for the new period");
            deliverable1CurrentPeriod.BalancingPaymentAmount.Should().Be(0m, "balancing payment should be zero for the new period");
            deliverable1CurrentPeriod.CappedPaymentAmount.Should().Be(0m, "capping payment should be zero for the new period");
            deliverable1CurrentPeriod.ReconciliationPaymentAmount.Should().Be(16.67m, "reconciliation payment should be apportioned and rounded to the nearest penny");
            deliverable1CurrentPeriod.NetPaymentAmount.Should().Be(16.67m, "net payment should be calculated and rounded to the nearest penny");

            CalculationResultLine deliverable2PreviousPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 2 && dp.Period == 202008);
            deliverable2PreviousPeriod.Should().NotBeNull("a previous period should be carried forward for deliverable 2");
            deliverable2PreviousPeriod.ProfileValue.Should().Be(200m, "profile payment should be carried forward for the previous period");
            deliverable2PreviousPeriod.BalancingPaymentAmount.Should().Be(2m, "balancing payment should be carried forward for the previous period");
            deliverable2PreviousPeriod.CappedPaymentAmount.Should().Be(0m, "capping payment should be carried forward for the previous period");
            deliverable2PreviousPeriod.ReconciliationPaymentAmount.Should().BeNull("reconciliation payment should be carried forward for the previous period");

            CalculationResultLine deliverable2CurrentPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 2 && dp.Period == 202009);
            deliverable2CurrentPeriod.Should().NotBeNull("a new period should be created for deliverable 2");
            deliverable2CurrentPeriod.ProfileValue.Should().Be(0m, "profile payment should be zero for the new period");
            deliverable2CurrentPeriod.BalancingPaymentAmount.Should().Be(0m, "balancing payment should be zero for the new period");
            deliverable2CurrentPeriod.CappedPaymentAmount.Should().Be(0m, "capping payment should be zero for the new period");
            deliverable2CurrentPeriod.ReconciliationPaymentAmount.Should().Be(33.33m, "reconciliation payment should be apportioned and rounded to the nearest penny");
            deliverable2CurrentPeriod.NetPaymentAmount.Should().Be(33.33m, "net payment should be calculated and rounded to the nearest penny");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PayOnProfileFundingClaimReconciliationPublishedBehaviour_WhenCurrentPeriodHasBeenCalculatedPreviously_ShouldBringForwardCalculatedPaymentsAndApportionReconciliationPayment()
        {
            // arrange
            const decimal fcrAllocationReconciliationValue = 50m;

            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 50, plannedVolume: 0) {ProfilePayment = 50},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 50, plannedVolume: 0) {ProfilePayment = 50, BalancingPayment = 50}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {ProfilePayment = 100},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0) {ProfilePayment = 100, BalancingPayment = 100}
                }, allowProfile : true, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(
                "ALLOC-1", 1, "FSP", inputDeliverables, "12345678", "ORG12345678", "CONTRACT-1", new List<CappingGroup>());

            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PayOnProfileFundingClaimReconciliationPublishedBehaviour.Calculate(input, new CensusPeriodInfo(DateTime.Now, 09, 2020), fcrAllocationReconciliationValue);

            // assert
            CalculationResultLine deliverable1CurrentPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 1 && dp.Period == 202009);
            deliverable1CurrentPeriod.Should().NotBeNull("the current period should be calculated for deliverable 1");
            deliverable1CurrentPeriod.ProfileValue.Should().Be(50m, "existing profile payment should be carried forward for current period");
            deliverable1CurrentPeriod.BalancingPaymentAmount.Should().Be(50m, "existing balancing payment should be zero for a current period");
            deliverable1CurrentPeriod.CappedPaymentAmount.Should().Be(0m, "existing capping payment should be zero for a current period");
            deliverable1CurrentPeriod.ReconciliationPaymentAmount.Should().Be(16.67m, "reconciliation payment should be apportioned and rounded to the nearest penny");

            CalculationResultLine deliverable2CurrentPeriod = calculationResultLines.SingleOrDefault(dp => dp.DeliverableCode == 2 && dp.Period == 202009);
            deliverable2CurrentPeriod.Should().NotBeNull("the current period should be calculated for deliverable 2");
            deliverable2CurrentPeriod.ProfileValue.Should().Be(100m, "existing profile payment should be carried forward for the current period");
            deliverable2CurrentPeriod.BalancingPaymentAmount.Should().Be(100m, "existing balancing payment should be carried forward for the current period");
            deliverable2CurrentPeriod.CappedPaymentAmount.Should().Be(0m, "existing capping payment should be zero for a current period");
            deliverable2CurrentPeriod.ReconciliationPaymentAmount.Should().Be(33.33m, "reconciliation payment should be apportioned and rounded to the nearest penny");
        }
    }
}
