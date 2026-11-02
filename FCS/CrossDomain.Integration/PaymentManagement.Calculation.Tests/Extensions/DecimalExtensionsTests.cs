namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class DecimalExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DecimalExtensions_TruncatePoundsToNearestPenny_ShouldTruncateValuesLessThanPenny()
        {
            const decimal value = -131.42857142857142857142857145m;

            // act
            var result = value.RoundPoundsToNearestPenny();

            // assert
            Assert.AreEqual(-131.43m, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DecimalExtensions_RoundPoundsDownToNearestPenny_ShouldIgnoreAnyFractions()
        {
            const decimal value = -310.6375m;

            // act
            var result = value.RoundPoundsDownToNearestPenny();

            // assert
            Assert.AreEqual(-310.63m, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DecimalExtensions_IsNegative_ShouldDecideWhetherNumberIsNegative()
        {
            List<(decimal? number, bool isNegative)> inputAndResults = new List<(decimal? number, bool isNegative)>
            {
                (-2, true),
                (null, false),
                (0, false),
                (1, false),
                (-20, true)
            };

            inputAndResults.ForEach(i =>
            {
                // act
                var result = i.number.IsNegative();

                // assert
                result.Should().Be(i.isNegative,  i.number.ToString());
            });
        }
    }
}
