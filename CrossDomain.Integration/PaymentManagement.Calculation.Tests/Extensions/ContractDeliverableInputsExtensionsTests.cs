namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ContractDeliverableInputsExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetActualsForGroupToDate_ReturnsActualsInFinancialYearUpToCurrentPeriod()
        {
            var inputs = new List<CalculationDeliverableInput>
            {
                CreateInput(
                    CreatePeriod(202007, actualValue: 10),
                    CreatePeriod(202008, actualValue: 20),
                    CreatePeriod(202009, actualValue: 30),
                    CreatePeriod(202104, actualValue: 40))
            };

            var actuals = inputs.GetActualsForGroupToDate(new Period(202008), new Period(202008));

            Assert.AreEqual(30, actuals);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetActualsToDate_ReturnsActualsAcrossDeliverablesUpToCurrentPeriod()
        {
            var inputs = new List<CalculationDeliverableInput>
            {
                CreateInput(CreatePeriod(202007, actualValue: 10), CreatePeriod(202008, actualValue: 20)),
                CreateInput(CreatePeriod(202008, actualValue: 30), CreatePeriod(202009, actualValue: 40))
            };

            var actuals = inputs.GetActualsToDate(new Period(202008));

            Assert.AreEqual(60, actuals);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetPlannedValue_SumsOnlyDeliverablesThatAllowProfile()
        {
            var inputs = new List<CalculationDeliverableInput>
            {
                CreateInput(true, CreatePeriod(202007, plannedValue: 10), CreatePeriod(202008, plannedValue: 20)),
                CreateInput(false, CreatePeriod(202007, plannedValue: 30))
            };

            var plannedValue = inputs.GetPlannedValue();

            Assert.AreEqual(30, plannedValue);
        }

        private static CalculationDeliverableInput CreateInput(params CalculationDeliverablePeriodInput[] periods)
        {
            return CreateInput(true, periods);
        }

        private static CalculationDeliverableInput CreateInput(bool allowProfile, params CalculationDeliverablePeriodInput[] periods)
        {
            return new CalculationDeliverableInput(
                1,
                new List<CalculationDeliverablePeriodInput>(periods),
                allowProfile,
                cappingApportionmentPriorityOrder: null,
                fundingStreamPeriodCappingGroupId: null);
        }

        private static CalculationDeliverablePeriodInput CreatePeriod(int period, decimal? actualValue = null, decimal? plannedValue = null)
        {
            return new CalculationDeliverablePeriodInput(period, plannedValue ?? 0, 0)
            {
                ActualValue = actualValue,
                PlannedValue = plannedValue
            };
        }
    }
}
