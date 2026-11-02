namespace PaymentManagement.Calculation.Tests.Dtos
{
    using System.Collections.Generic;
    using Calculation.Dtos;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class PeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Period_ShouldGetTaxYearWhenTheMonthIsGreaterThanMarch()
        {
            // arrange
            Period periodInput = new Period(202008);

            // act
            var taxYear = periodInput.GetTaxYear();

            // assert
            Assert.AreEqual(2021, taxYear);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_ShouldGetTaxYearWhenTheMonthIsLessThanMarch()
        {
            // arrange
            Period periodInput = new Period(202001);

            // act
            var taxYear = periodInput.GetTaxYear();

            // assert
            Assert.AreEqual(1920, taxYear);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_ShouldGetPreviousTaxYearWhenTheMonthIsLessThanMarch()
        {
            // arrange
            Period periodInput = new Period(202001);

            // act
            var taxYear = periodInput.GetPreviousTaxYear();

            // assert
            Assert.AreEqual(1819, taxYear);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void Period_ShouldGetPreviousTaxYearWhenTheMonthIsGreaterThanMarch()
        {
            // arrange
            Period periodInput = new Period(202004);

            // act
            var taxYear = periodInput.GetPreviousTaxYear();

            // assert
            Assert.AreEqual(1920, taxYear);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_AddMonths()
        {
            // arrange
            Period periodInput = new Period(202004);
            List<(Period initial, int months, Period expected)> inputAndExpected =
                new List<(Period initial, int months, Period expected)>
                {
                    (202004, 1, 202005),
                    (202210, 3, 202301),
                    (202201, 4, 202205),
                };

            // act
            inputAndExpected.ForEach(i =>
            {
                var result = i.initial.AddMonths(i.months);

                // assert
                result.Should().Be(i.expected);
            });
            
        }
    }
}
