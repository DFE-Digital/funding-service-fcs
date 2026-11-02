namespace FCT.Operations.Tests.PaymentSummary
{
    using System;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Extensions;

    [TestClass]
    public class ReportingPeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportPeriod_ShouldInitializeProperties()
        {
            // act
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 10));

            // assert
            reportingPeriod.Period.Should().Be("Dec 2022");
            reportingPeriod.PeriodAsInt.Should().Be(202212);
            reportingPeriod.Year.Should().Be(2022);
            reportingPeriod.Month.Should().Be(12);
            reportingPeriod.Day.Should().Be(10);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportPeriod_ShouldReturnPaymentSummaryReportFilename()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 07));

            // act
            string filename = reportingPeriod.ToPaymentSummaryReportFilename();

            // assert
            filename.Should().Be("2022-12 Payments.xlsx");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportPeriod_ShouldReturnPaymentSummaryReportWorkbookTitle()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2020, 05, 10));

            // act
            string filename = reportingPeriod.ToPaymentSummaryReportWorkbookTitle();

            // assert
            filename.Should().Be("FCS Consolidated Payment Summary Report - May 2020");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportPeriod_ShouldReturnPOPPaymentSummaryReportFilenameIn3rdthWorkingDay()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 02));

            // act
            string filename = reportingPeriod.ToPaymentSummaryReportFilename();

            // assert
            filename.Should().Be("2022-12 Grant funding.xlsx");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportPeriod_ShouldReturnAllPaymentSummaryReportFileIn7thWorkingDay()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 07));

            // act
            string filename = reportingPeriod.ToPaymentSummaryReportFilename();

            // assert
            filename.Should().Be("2022-12 Payments.xlsx");
        }
    }
}
