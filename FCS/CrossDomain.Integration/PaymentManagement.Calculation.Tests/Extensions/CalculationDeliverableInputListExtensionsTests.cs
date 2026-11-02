namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Dtos;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CalculationDeliverableInputListExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInputListExtensions_ShouldGetTotalCappingPaymentOfZero_WhenActualsAreLessThanPlannedValues()
        {
            // arrange
            List<CalculationDeliverableInput> calculationDeliverableInputs = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(
                    1,
                    new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202007, plannedValue: 100, plannedVolume: 0) {ActualValue = 10},
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 110, plannedVolume: 0) {ActualValue = 11},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 120, plannedVolume: 0) {ActualValue = 30}
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            const int currentPeriod = 202008;

            // act
            var totalCappingPayment = calculationDeliverableInputs.GetTotalCappingPayment(currentPeriod, 0);
            // assert
            Assert.AreEqual(0, totalCappingPayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInputListExtensions_ShouldGetTotalCappingPayment_WhenActualsAreMoreThanPlannedValues()
        {
            // arrange
            List<CalculationDeliverableInput> calculationDeliverableInputs = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(
                    1,
                    new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202007, plannedValue: 100, plannedVolume: 0) {ActualValue = 100},
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 110, plannedVolume: 0) {ActualValue = 300},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 120, plannedVolume: 0) {ActualValue = 30}
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            const int currentPeriod = 202008;

            // act
            var totalCappingPayment = calculationDeliverableInputs.GetTotalCappingPayment(currentPeriod, 0);
            // assert
            Assert.AreEqual(-70, totalCappingPayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInputListExtensions_ShouldGetTotalCappingPayment_WhenActualsAreMoreThanPlannedValuesAndOverDelivery()
        {
            // arrange
            List<CalculationDeliverableInput> calculationDeliverableInputs = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(
                    1,
                    new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202007, plannedValue: 100, plannedVolume: 0) {ActualValue = 100},
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 100, plannedVolume: 0) {ActualValue = 300},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 100, plannedVolume: 0) {ActualValue = 30}
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            const int currentPeriod = 202008;

            // act
            var totalCappingPayment = calculationDeliverableInputs.GetTotalCappingPayment(currentPeriod, 10);
            
            // assert
            // 300 * 110% = 330, therefore the 330 - 400
            Assert.AreEqual(-70, totalCappingPayment);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CalculationDeliverableInputListExtensions_ShouldGetTotalActualsToDate()
        {
            // arrange
            List<CalculationDeliverableInput> calculationDeliverableInputs = new List<CalculationDeliverableInput>
            {
                new CalculationDeliverableInput(
                    1,
                    new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202007, plannedValue: 100, plannedVolume: 0) {ActualValue = 100},
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 110, plannedVolume: 0) {ActualValue = 300},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 120, plannedVolume: 0) {ActualValue = 30}
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
                new CalculationDeliverableInput(
                    2,
                    new List<CalculationDeliverablePeriodInput>
                    {
                        new CalculationDeliverablePeriodInput(period: 202007, plannedValue: 100, plannedVolume: 0) {ActualValue = 100},
                        new CalculationDeliverablePeriodInput(period: 202008, plannedValue: 110, plannedVolume: 0) {ActualValue = 500},
                        new CalculationDeliverablePeriodInput(period: 202009, plannedValue: 120, plannedVolume: 0) {ActualValue = 30}
                    }, allowProfile: true, cappingApportionmentPriorityOrder: null, fundingStreamPeriodCappingGroupId: null),
            };

            const int currentPeriod = 202008;

            // act
            var totalActualsToDate = calculationDeliverableInputs.GetTotalActualsToDate(currentPeriod);
            // assert
            Assert.AreEqual(1000, totalActualsToDate);
        }
    }
}
