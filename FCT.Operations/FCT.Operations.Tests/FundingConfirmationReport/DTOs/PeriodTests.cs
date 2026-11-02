namespace FCT.Operations.Tests.FundingConfirmationReport.DTOs
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.FundingConfirmationReport.DTOs;

    [TestClass]
    public class PeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void Period_GetAcademicYearStart_ShouldReturnCorrectVal()
        {
            // arrange
            var inputsWithResult = new List<(int period, int startAcademicYear)>
            {
                (1920, 201908),
                (2021, 202008),
                (2122, 202108),
            };

            inputsWithResult.ForEach(i =>
            {
                // act and assert
                new Period(i.period).GetAcademicYearStart().Should().Be(i.startAcademicYear);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_GetAcademicYearEnd_ShouldReturnCorrectVal()
        {
            // arrange
            var inputsWithResult = new List<(int period, int endAcademicYear)>
            {
                (1920, 202007),
                (2021, 202107),
                (2122, 202207),
            };

            inputsWithResult.ForEach(i =>
            {
                // act and assert
                new Period(i.period).GetAcademicYearEnd().Should().Be(i.endAcademicYear);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_GetFinancialYearStart_ShouldReturnCorrectVal()
        {
            // arrange
            var inputsWithResult = new List<(int period, int financialYearStart)>
            {
                (1920, 201904),
                (2021, 202004),
                (2122, 202104),
            };

            inputsWithResult.ForEach(i =>
            {
                // act and assert
                new Period(i.period).GetFinancialYearStart().Should().Be(i.financialYearStart);
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Period_GetFinancialYearEnd_ShouldReturnCorrectVal()
        {
            // arrange
            var inputsWithResult = new List<(int period, int financialYearEnd)>
            {
                (1920, 202003),
                (2021, 202103),
                (2122, 202203),
            };

            inputsWithResult.ForEach(i =>
            {
                // act and assert
                new Period(i.period).GetFinancialYearEnd().Should().Be(i.financialYearEnd);
            });
        }
    }
}
