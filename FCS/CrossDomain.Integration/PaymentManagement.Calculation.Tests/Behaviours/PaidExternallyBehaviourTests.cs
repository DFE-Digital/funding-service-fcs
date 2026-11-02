namespace PaymentManagement.Calculation.Tests.Behaviours
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations;

    [TestClass]
    public class PaidExternallyBehaviourTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaidExternallyBehaviour_ShouldReturnActualValueAsReconciliationWhenDeliverableIsPayable()
        {
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 150, plannedVolume: 0){ActualValue = 11},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 150, plannedVolume: 0){ActualValue = 12},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 150, plannedVolume: 0){ActualValue = 13},
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 150, plannedVolume: 0){ActualValue = 14},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 150, plannedVolume: 0){ActualValue = 15},
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0){ActualValue = 16},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 150, plannedVolume: 0){ActualValue = 17},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 150, plannedVolume: 0){ActualValue = 18},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 150, plannedVolume: 0){ActualValue = 19},
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 150, plannedVolume: 0){ActualValue = 20},
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 200, plannedVolume: 0){ActualValue = 21},

                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 30},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 31},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 32},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0){ActualValue = 33},
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 34},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0){ActualValue = 35},
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 36},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 37},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 38},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 39},
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0){ActualValue = 30},
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0){ActualValue = 31},
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null, allowPayment:false),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 8, 2021);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PaidExternallyBehaviour.Calculate(input, currentPeriod);

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(dp.ActualValue, resultLine.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
                Assert.AreEqual(dp.ActualValue, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
            });
            const int deliverableCode2 = 2;
            inputDeliverables.Single(d => d.DeliverableCode == deliverableCode2).DeliverablePeriods.ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == deliverableCode2 && r.Period == dp.Period);
                Assert.AreEqual(dp.ReconciliationPayment, resultLine.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount for deliverable code 2 and period: {dp.Period} is not right");
                Assert.AreEqual(dp.NetPayment, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 2 and period: {dp.Period} is not right");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaidExternallyBehaviour_ShouldReturnZeroReconciliationPeriodsAreInTheFuture()
        {
            List<CalculationDeliverableInput> inputDeliverables = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(1, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0){ActualValue = 10},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 150, plannedVolume: 0){ActualValue = 11},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 150, plannedVolume: 0){ActualValue = 12},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 150, plannedVolume: 0){ActualValue = 13},
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 150, plannedVolume: 0){ActualValue = 14},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 150, plannedVolume: 0){ActualValue = 15},
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 150, plannedVolume: 0){ActualValue = 16},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 150, plannedVolume: 0){ActualValue = 17},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 150, plannedVolume: 0){ActualValue = 18},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 150, plannedVolume: 0){ActualValue = 19},
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 150, plannedVolume: 0){ActualValue = 20},
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 200, plannedVolume: 0){ActualValue = 21},

                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null, allowPayment:true),
                new CalculationDeliverableInput(2, new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 0, plannedVolume: 0){ActualValue = 30},
                    new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 0, plannedVolume: 0){ActualValue = 31},
                    new CalculationDeliverablePeriodInput(period: 202010, plannedValue: 0, plannedVolume: 0){ActualValue = 32},
                    new CalculationDeliverablePeriodInput(period: 202011, plannedValue: 0, plannedVolume: 0){ActualValue = 33},
                    new CalculationDeliverablePeriodInput(period: 202012, plannedValue: 0, plannedVolume: 0){ActualValue = 34},
                    new CalculationDeliverablePeriodInput(period: 202101, plannedValue: 0, plannedVolume: 0){ActualValue = 35},
                    new CalculationDeliverablePeriodInput(period: 202102, plannedValue: 0, plannedVolume: 0){ActualValue = 36},
                    new CalculationDeliverablePeriodInput(period: 202103, plannedValue: 0, plannedVolume: 0){ActualValue = 37},
                    new CalculationDeliverablePeriodInput(period: 202104, plannedValue: 0, plannedVolume: 0){ActualValue = 38},
                    new CalculationDeliverablePeriodInput(period: 202105, plannedValue: 0, plannedVolume: 0){ActualValue = 39},
                    new CalculationDeliverablePeriodInput(period: 202106, plannedValue: 0, plannedVolume: 0){ActualValue = 30},
                    new CalculationDeliverablePeriodInput(period: 202107, plannedValue: 0, plannedVolume: 0){ActualValue = 31},
                }, allowProfile : false, cappingApportionmentPriorityOrder: null, null, allowPayment:false),
            };

            CalculationAllocationInput input = new CalculationAllocationInput(string.Empty, 1, string.Empty, inputDeliverables, string.Empty, string.Empty, string.Empty, new List<CappingGroup>());
            var currentPeriod = new CensusPeriodInfo(DateTime.MinValue, 1, 2021);
            // act
            IReadOnlyCollection<CalculationResultLine> calculationResultLines =
                PaidExternallyBehaviour.Calculate(input, currentPeriod);

            // assert
            inputDeliverables.Single(d => d.DeliverableCode == 1).DeliverablePeriods.Where(dp => dp.Period > currentPeriod.GetPeriod()).ToList().ForEach(dp =>
            {
                var resultLine = calculationResultLines.Single(r => r.DeliverableCode == 1 && r.Period == dp.Period);
                Assert.AreEqual(null, resultLine.ReconciliationPaymentAmount, $"The ReconciliationPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
                Assert.AreEqual(0, resultLine.NetPaymentAmount, $"The NetPaymentAmount for deliverable code 1 and period: {dp.Period} is not right");
            });
        }

    }
}
