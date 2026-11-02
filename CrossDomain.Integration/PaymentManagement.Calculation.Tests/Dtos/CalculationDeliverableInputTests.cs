namespace PaymentManagement.Calculation.Tests.Dtos
{
    using System.Collections.Generic;
    using System.Linq;
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CalculationDeliverableInputTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInput_ShouldGetPeriodsInFirstFinancialPeriod_WhenCurrentPeriodIsInFirstFP()
        {
            // arrange
            CalculationDeliverableInput input = new CalculationDeliverableInput(1,
                new List<CalculationDeliverablePeriodInput>
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
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null);

            const int currentPeriod = 202103;

            // act
            var periods = input.GetPeriodsForThisFinancialYear(currentPeriod);

            // assert
            Assert.AreEqual(8, periods.Count, "The number of periods is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInput_ShouldGetPeriodsInSecondFinancialPeriod_WhenCurrentPeriodIsInSecondFP()
        {
            // arrange
            CalculationDeliverableInput input = new CalculationDeliverableInput(1,
                new List<CalculationDeliverablePeriodInput>
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
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null);

            const int currentPeriod = 202104;

            // act
            var periods = input.GetPeriodsForThisFinancialYear(currentPeriod);

            // assert
            Assert.AreEqual(4, periods.Count, "The number of periods is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInput_ShouldGetPeriodsInSecondFinancialPeriod_WhenCurrentPeriodIsPostYearEnd()
        {
            // arrange
            CalculationDeliverableInput input = new CalculationDeliverableInput(1,
                new List<CalculationDeliverablePeriodInput>
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
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null); 
            const int currentPeriod = 202108;

            var x = input.DeliverablePeriods.ToLookup(dp => new Period(dp.Period).GetTaxYear());

            // act
            var periods = input.GetPeriodsForThisFinancialYear(currentPeriod);

            // assert
            Assert.AreEqual(4, periods.Count, "The number of periods is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInput_ShouldGetPeriodsForPreviousFinancialYear_WhenCurrentPeriodIsPostYearEnd()
        {
            // arrange
            CalculationDeliverableInput input = new CalculationDeliverableInput(1,
                new List<CalculationDeliverablePeriodInput>
                {
                    new CalculationDeliverablePeriodInput(period: 201608, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201609, plannedValue: 8000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201610, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201611, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201612, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201701, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201702, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201703, plannedValue: 0, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201704, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201705, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201706, plannedValue: 2000, plannedVolume: 0),
                    new CalculationDeliverablePeriodInput(period: 201707, plannedValue: 2000, plannedVolume: 0),
                }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null);

            const int currentPeriod = 201708;

            // act
            var periods = input.GetPeriodsForPreviousFinancialYear(currentPeriod);

            // assert
            Assert.AreEqual(8, periods.Count, "The number of periods is not correct");
        }
    }
}
