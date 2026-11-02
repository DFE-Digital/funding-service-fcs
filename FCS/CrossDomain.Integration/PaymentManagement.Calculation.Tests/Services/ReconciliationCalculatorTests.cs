namespace PaymentManagement.Calculation.Tests.Services
{
    using Calculation.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Services;

    [TestClass]
    public class ReconciliationCalculatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculator_WhenNoPreviousPaymentsHaveBeenMade_ShouldReconcileToExpectedValue()
        {
            // arrange
            CalculationDeliverablePeriodInput[] calculationInputs =
            {
                new CalculationDeliverablePeriodInput(202001, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202002, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202003, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202004, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202005, 1, 10m)
            };

            const int currentPeriod = 202005;

            // act
            decimal? reconciliationValue = ReconciliationCalculator.CalculateReconciliationPayment(calculationInputs, currentPeriod);

            // assert
            Assert.AreEqual(50m, reconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculator_WhenPreviousPaymentsHaveBeenMade_ShouldReconcileToExpectedValue()
        {
            // arrange
            CalculationDeliverablePeriodInput[] calculationInputs =
            {
                new CalculationDeliverablePeriodInput(202001, 1, 10m) { NetPayment = 10 },
                new CalculationDeliverablePeriodInput(202002, 1, 10m) { NetPayment = 10 },
                new CalculationDeliverablePeriodInput(202003, 1, 10m) { NetPayment = 10 },
                new CalculationDeliverablePeriodInput(202004, 1, 10m) { NetPayment = 10 },
                new CalculationDeliverablePeriodInput(202005, 1, 10m) { NetPayment = 10 }
            };

            const int currentPeriod = 202005;

            // act
            decimal? reconciliationValue = ReconciliationCalculator.CalculateReconciliationPayment(calculationInputs, currentPeriod);

            // assert
            Assert.AreEqual(10m, reconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculator_WhenPreviousActualsAreRestatedWithDifferentValues_ShouldReconcileToExpectedValue()
        {
            // arrange
            CalculationDeliverablePeriodInput[] calculationInputs =
            {
                    new CalculationDeliverablePeriodInput(202001, 1,11m ) { NetPayment = 10m },
                    new CalculationDeliverablePeriodInput(202002, 1,11m ) { NetPayment = 10m },
                    new CalculationDeliverablePeriodInput(202003, 1,11m ) { NetPayment = 10m },
                    new CalculationDeliverablePeriodInput(202004, 1,11m ) { NetPayment = 10m },
                    new CalculationDeliverablePeriodInput(202005, 1,10m )
                };

            const int currentPeriod = 202005;

            // act
            decimal? reconciliationValue = ReconciliationCalculator.CalculateReconciliationPayment(calculationInputs, currentPeriod);

            // assert
            Assert.AreEqual(14m, reconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculator_ShouldExcludeFutureActualsFromReconciliation()
        {
            // arrange
            CalculationDeliverablePeriodInput[] calculationInputs =
            {
                new CalculationDeliverablePeriodInput(202001, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202002, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202003, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202004, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202005, 1, 10m) { NetPayment = 0 },
                new CalculationDeliverablePeriodInput(202006, 1, 10m),
                new CalculationDeliverablePeriodInput(202007, 1, 10m),
                new CalculationDeliverablePeriodInput(202008, 1, 10m),
                new CalculationDeliverablePeriodInput(202009, 1, 10m),
                new CalculationDeliverablePeriodInput(202010, 1, 10m),
                new CalculationDeliverablePeriodInput(202011, 1, 10m),
                new CalculationDeliverablePeriodInput(202012, 1, 10m)
            };
            const int currentPeriod = 202005;

            // act
            decimal? reconciliationValue = ReconciliationCalculator.CalculateReconciliationPayment(calculationInputs, currentPeriod);

            // assert
            Assert.AreEqual(50m, reconciliationValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReconciliationCalculator_ShouldExcludeExistingPaymentForCurrentPeriodFromReconciliation()
        {
            // arrange
            CalculationDeliverablePeriodInput[] calculationInputs =
            {
                new CalculationDeliverablePeriodInput(202001, 1, 10m) { NetPayment = 10m },
                new CalculationDeliverablePeriodInput(202002, 1, 10m) { NetPayment = 10m },
                new CalculationDeliverablePeriodInput(202003, 1, 10m) { NetPayment = 10m },
                new CalculationDeliverablePeriodInput(202004, 1, 10m) { NetPayment = 10m },
                new CalculationDeliverablePeriodInput(202005, 1, 10m) { NetPayment = 10m },
                new CalculationDeliverablePeriodInput(202006, 1, 10m),
                new CalculationDeliverablePeriodInput(202007, 1, 10m),
                new CalculationDeliverablePeriodInput(202008, 1, 10m),
                new CalculationDeliverablePeriodInput(202009, 1, 10m),
                new CalculationDeliverablePeriodInput(202010, 1, 10m),
                new CalculationDeliverablePeriodInput(202011, 1, 10m),
                new CalculationDeliverablePeriodInput(202012, 1, 10m)
            };

            const int currentPeriod = 202005;

            // act
            decimal? reconciliationValue = ReconciliationCalculator.CalculateReconciliationPayment(calculationInputs, currentPeriod);

            // assert
            Assert.AreEqual(10m, reconciliationValue);
        }
    }
}
