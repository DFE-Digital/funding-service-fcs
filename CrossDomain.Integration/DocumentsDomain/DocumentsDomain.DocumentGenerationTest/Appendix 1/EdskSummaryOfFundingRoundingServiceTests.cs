namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_1
{
    using System.Linq;
    using DocumentDefiner.DocumentPartCreators;
    using DocumentDefiner.DocumentPartCreators.Appendix1;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class EdskSummaryOfFundingRoundingServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingRoundingService_ShouldRoundForEdFsp_WhenPeriodOneGreaterPence()
        {
            // arrange
            const decimal periodOne = 78564.82M;
            const decimal periodTwo = 53544.70M;
            const decimal total = 132109.52M;

            // act
            var result = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOne, periodTwo, total,
                fundingStreamPeriodCode: "1619ED1920");

            // assert
            Assert.AreEqual(78565, result.PeriodOne, "The period one value is wrong");
            Assert.AreEqual(53544, result.PeriodTwo, "The period two value is wrong");
            Assert.AreEqual(132109, result.Total, "The total value is wrong");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingRoundingService_ShouldRoundForEdFsp_WhenPeriodTwoGreaterPence()
        {
            // arrange
            const decimal periodOne = 78564.42M;
            const decimal periodTwo = 53544.70M;
            const decimal total = 132109.32M;

            // act
            var result = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOne, periodTwo, total,
                fundingStreamPeriodCode: "1619ED1920");

            // assert
            Assert.AreEqual(78564, result.PeriodOne, "The period one value is wrong");
            Assert.AreEqual(53545, result.PeriodTwo, "The period two value is wrong");
            Assert.AreEqual(132109, result.Total, "The total value is wrong");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingRoundingService_ShouldNotRoundForOtherFsps()
        {
            // arrange
            const decimal periodOne = 78564.82M;
            const decimal periodTwo = 53544.70M;
            const decimal total = 132109.52M;

            // act
            var result = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(periodOne, periodTwo, total,
                fundingStreamPeriodCode: "other");

            // assert
            Assert.AreEqual(periodOne, result.PeriodOne, "The period one value is wrong");
            Assert.AreEqual(periodTwo, result.PeriodTwo, "The period two value is wrong");
            Assert.AreEqual(total, result.Total, "The total value is wrong");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskSummaryOfFundingRoundingService_ShouldReturnSameValuesAsKnownExamples()
        {
            // arrange
            (decimal inputFY1, decimal inputFY2, decimal inputTotal, decimal expectedFY1, decimal expectedFY2, decimal expectedTotal)[] examples =
            {
                (2000000, 1000000.99m, 3000000.99m, 2000000, 1000000, 3000000),
                (2000000.01m, 1000000.99m, 3000001.00m, 2000000m, 1000001m, 3000001),
                (1000000.49m, 2000000.49m, 3000000.98m, 1000000, 2000000, 3000000),
                (2000000.49m, 1000000.51m, 3000001, 2000000, 1000001, 3000001),
                (0.99m, 1000000.01m, 1000001, 1, 1000000, 1000001),
                (0.60m, 1000000.70m, 1000001.30m, 0, 1000001, 1000001),
                (10.99m, 1000000.99m, 1000011.98m, 10, 1000001, 1000011),
                (1000000.50m, 1000000.50m, 2000001, 1000000, 1000001, 2000001),
                (-100.99m, -200.49m, -301.48m, -101, -200, -301)
            };

            examples.ToList().ForEach(example =>
            {
                // act
                var (inputFy1, inputFy2, inputTotal, expectedFy1, expectedFy2, expectedTotal) = example;

                EdskSummaryRowResult result = EdskSummaryOfFundingRoundingService.GetSummaryRowResult(
                    inputFy1,
                    inputFy2,
                    inputTotal,
                    fundingStreamPeriodCode: "1619ED1920");

                // assert
                Assert.AreEqual(expectedFy1, result.PeriodOne, "The period one value is wrong");
                Assert.AreEqual(expectedFy2, result.PeriodTwo, "The period two value is wrong");
                Assert.AreEqual(expectedTotal, result.Total, "The total value is wrong");
            });
        }
    }
}
