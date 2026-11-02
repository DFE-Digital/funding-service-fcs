namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval.Services
{
    using System;
    using Endpoint.InitiateContractApproval.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class LevyContractStartDateCalculatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractStartDateCalculator_WhenOriginalContractAndDuringOriginalContractTerminationNoticePeriod_ShouldReturnCurrentDate()
        {
            // arrange
            const string originalContractNumber = "APPLEVY-4999";
            DateTime dateDuringOriginalContractTerminationNoticePeriod = new DateTime(2020, 04, 06, 0, 0, 0, DateTimeKind.Utc);

            // act
            DateTime currentDate = dateDuringOriginalContractTerminationNoticePeriod;
            DateTime calculatedStartDate = LevyContractStartDateCalculator.GetStartDate(originalContractNumber, currentDate);

            // assert
            Assert.AreEqual(currentDate, calculatedStartDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractStartDateCalculator_WhenOriginalContractAndAfterOriginalContractTerminationNoticePeriod_ShouldReturnCurrentDate()
        {
            // arrange
            const string originalContractNumber = "APPLEVY-4999";
            DateTime dateAfterOriginalContractTerminationNoticePeriod = new DateTime(2020, 04, 07, 0, 0, 0, DateTimeKind.Utc);

            // act
            DateTime currentDate = dateAfterOriginalContractTerminationNoticePeriod;
            DateTime calculatedStartDate = LevyContractStartDateCalculator.GetStartDate(originalContractNumber, currentDate);

            // assert
            Assert.AreEqual(currentDate, calculatedStartDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractStartDateCalculator_WhenPostApril2020ContractAndDuringOriginalContractTerminationNoticePeriod_ShouldReturnLastDayOfMarch()
        {
            // arrange
            const string postApril2020ContractNumber = "APPLEVY-5000";
            DateTime dateDuringOriginalContractTerminationNoticePeriod = new DateTime(2020, 04, 06, 0, 0, 0, DateTimeKind.Utc);
            DateTime lastDayOfMarch = new DateTime(2020, 03, 31, 0, 0, 0, DateTimeKind.Utc);

            // act
            DateTime currentDate = dateDuringOriginalContractTerminationNoticePeriod;
            DateTime calculatedStartDate = LevyContractStartDateCalculator.GetStartDate(postApril2020ContractNumber, currentDate);

            // assert
            Assert.AreEqual(lastDayOfMarch, calculatedStartDate);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractStartDateCalculator_WhenPostApril2020ContractAndAfterOriginalContractTerminationNoticePeriod_ShouldReturnCurrentDate()
        {
            // arrange
            const string postApril2020ContractNumber = "APPLEVY-5000";
            DateTime dateAfterOriginalContractTerminationNoticePeriod = new DateTime(2020, 04, 07, 0, 0, 0, DateTimeKind.Utc);

            // act
            DateTime currentDate = dateAfterOriginalContractTerminationNoticePeriod;
            DateTime calculatedStartDate = LevyContractStartDateCalculator.GetStartDate(postApril2020ContractNumber, currentDate);

            // assert
            Assert.AreEqual(currentDate, calculatedStartDate);
        }
    }
}
