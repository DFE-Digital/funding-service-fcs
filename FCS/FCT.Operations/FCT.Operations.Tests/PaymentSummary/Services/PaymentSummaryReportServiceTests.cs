namespace FCT.Operations.Tests.PaymentSummary.Services
{
    using System;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Operations.PaymentSummary.Repositories;
    using Operations.PaymentSummary.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Collections.Generic;
    using FCT.Operations.PaymentSummary;
    using System.Linq;

    [TestClass]
    public class PaymentSummaryReportServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSummaryReportService_ShouldGeneratePaymentSummaryReport_WhenLastRelevantCensusDateHasPassedAndReportNotYetGenerated_ShouldReturnTrue()
        {
            // arrange
            var fundingStreamPeriodCensusDateRepositoryMock = new Mock<IFundingStreamPeriodCensusDateRepository>();
            fundingStreamPeriodCensusDateRepositoryMock
                .Setup(m => m.HaveAllPaidCensusDatesPassedForCensusPeriod(It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);
            var workbookStorageRepositoryMock = new Mock<IWorkbookStorageRepository>();
            workbookStorageRepositoryMock
                .Setup(m => m.Exists(It.IsAny<string>()))
                .Returns(false);

            var service = new PaymentSummaryReportService(
                fundingStreamPeriodCensusDateRepositoryMock.Object,
                workbookStorageRepositoryMock.Object);

            var currentTime = new DateTime(2022, 12, 08, 22, 0, 0, DateTimeKind.Utc);

            // act
            bool shouldGeneratePaymentSummaryReport = service.ShouldGeneratePaymentSummaryReport(currentTime, ConnectionInfo.CreateDefault()).Result;

            // assert
            shouldGeneratePaymentSummaryReport.Should().BeTrue();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSummaryReportService_ShouldGeneratePaymentSummaryReport_WhenLastRelevantCensusDateHasPassedButReportAlreadyGenerated_ShouldReturnFalse()
        {
            // arrange
            var fundingStreamPeriodCensusDateRepositoryMock = new Mock<IFundingStreamPeriodCensusDateRepository>();
            fundingStreamPeriodCensusDateRepositoryMock
                .Setup(m => m.HaveAllPaidCensusDatesPassedForCensusPeriod(It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(true);
            var workbookStorageRepositoryMock = new Mock<IWorkbookStorageRepository>();
            workbookStorageRepositoryMock
                .Setup(m => m.Exists(It.IsAny<string>()))
                .Returns(true);

            var service = new PaymentSummaryReportService(
                fundingStreamPeriodCensusDateRepositoryMock.Object,
                workbookStorageRepositoryMock.Object);

            var currentTime = new DateTime(2022, 11, 08, 22, 0, 0, DateTimeKind.Utc);

            // act
            bool shouldGeneratePaymentSummaryReport = service.ShouldGeneratePaymentSummaryReport(currentTime, ConnectionInfo.CreateDefault()).Result;

            // assert
            shouldGeneratePaymentSummaryReport.Should().BeFalse();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSummaryReportService_ShouldGeneratePaymentSummaryReport_WhenLastRelevantCensusDateHasNotPassed_ShouldReturnFalse()
        {
            // arrange
            var fundingStreamPeriodCensusDateRepositoryMock = new Mock<IFundingStreamPeriodCensusDateRepository>();
            fundingStreamPeriodCensusDateRepositoryMock
                .Setup(m => m.HaveAllPaidCensusDatesPassedForCensusPeriod(It.IsAny<DateTime>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(false);
            var workbookStorageRepositoryMock = new Mock<IWorkbookStorageRepository>();
            workbookStorageRepositoryMock
                .Setup(m => m.Exists(It.IsAny<string>()))
                .Returns(false);

            var service = new PaymentSummaryReportService(
                fundingStreamPeriodCensusDateRepositoryMock.Object,
                workbookStorageRepositoryMock.Object);

            var currentTime = new DateTime(2022, 12, 07, 22, 0, 0, DateTimeKind.Utc);

            // act
            bool shouldGeneratePaymentSummaryReport = service.ShouldGeneratePaymentSummaryReport(currentTime, ConnectionInfo.CreateDefault()).Result;

            // assert
            shouldGeneratePaymentSummaryReport.Should().BeFalse();
        }
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSummaryReportService_ShouldFilterOutProvidersWithNoValues()
        {
            // arrange
            List<PaymentSummaryLine> paymentSummaryLines = new List<PaymentSummaryLine>
            {
                new PaymentSummaryLine(80000001, "PROVIDER 1","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 0,""),
                    new FspPayment("FSP 2", 0,""),
                    new FspPayment("FSP 3", 0,""),
                }),
                new PaymentSummaryLine(80000002, "PROVIDER 2","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 1000000,""),
                    new FspPayment("FSP 2", -100,""),
                    new FspPayment("FSP 3", 10,""),
                }),
                new PaymentSummaryLine(80000003, "PROVIDER 3","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 500,""),
                    new FspPayment("FSP 2", -500,""),
                    new FspPayment("FSP 3", 0,""),
                }),
                new PaymentSummaryLine(80000004, "PROVIDER 4","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 500),
                    new FspPayment("FSP 2", 0),
                    new FspPayment("FSP 3", 1),
                }),
                new PaymentSummaryLine(80000005, "PROVIDER 1","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 0,""),
                    new FspPayment("FSP 2", 0,""),
                    new FspPayment("FSP 3", 0,""),
                }),

            };

            var service = new PaymentSummaryReportService(Mock.Of<IFundingStreamPeriodCensusDateRepository>(),
                Mock.Of<IWorkbookStorageRepository>());

            // act
            var assertPaymentSummaryLines = service.FilterOutUnnecessaryLines(paymentSummaryLines);

            // assert
            Assert.AreEqual(3, assertPaymentSummaryLines.Count, "The number of payment lines is not right");
            List<int> shouldBeIncluded = new List<int>{80000002, 80000002, 80000004};

            Assert.IsTrue(shouldBeIncluded.All(ukprn => assertPaymentSummaryLines.Select(pl => pl.Ukprn).Contains(ukprn)), "The ukprns are not right");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentSummaryReportService_ShouldFilterOutFspsWthNoValues()
        {
            // arrange
            const string fspToRemove30 = "FSP 30";
            const string fspToRemove40 = "FSP 40";
            const string fspToRemove50 = "FSP 50";
            List<PaymentSummaryLine> paymentSummaryLines = new List<PaymentSummaryLine>
            {
                new PaymentSummaryLine(80000001, "PROVIDER 1","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", -100,""),
                    new FspPayment("FSP 2", 600,""),
                    new FspPayment(fspToRemove30, 0,""),
                    new FspPayment(fspToRemove40, 0,""),
                    new FspPayment(fspToRemove50, 0,""),
                    new FspPayment("FSP 60", 600,""),
                }),
                new PaymentSummaryLine(80000002, "PROVIDER 2","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 1000000,""),
                    new FspPayment("FSP 2", -100,""),
                    new FspPayment(fspToRemove30, 0,""),
                    new FspPayment(fspToRemove40, 0,""),
                    new FspPayment(fspToRemove50, 0,""),
                    new FspPayment("FSP 60", 600,""),
                }),
                new PaymentSummaryLine(80000003, "PROVIDER 3","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 500,""),
                    new FspPayment("FSP 2", -500,""),
                    new FspPayment(fspToRemove30, 0,""),
                    new FspPayment(fspToRemove40, 0,""),
                    new FspPayment(fspToRemove50, 0,""),
                    new FspPayment("FSP 60", 600,""),
                }),
            };
            var service = new PaymentSummaryReportService(Mock.Of<IFundingStreamPeriodCensusDateRepository>(),
                Mock.Of<IWorkbookStorageRepository>());

            // act
            var assertPaymentSummaryLines = service.FilterOutUnnecessaryLines(paymentSummaryLines);

            // assert
            var allFspPayments = assertPaymentSummaryLines.SelectMany(lines => lines.Payments).ToList();

            var fsp30PaymentsThatShouldNotExist = allFspPayments.Where(payment => payment.Fsp == fspToRemove30).ToList();
            Assert.AreEqual(0, fsp30PaymentsThatShouldNotExist.Count, $"{fspToRemove30} was not removed");

            var fsp40PaymentsThatShouldNotExist = allFspPayments.Where(payment => payment.Fsp == fspToRemove40).ToList();
            Assert.AreEqual(0, fsp40PaymentsThatShouldNotExist.Count, $"{fspToRemove40} was not removed");

            var fsp50PaymentsThatShouldNotExist = allFspPayments.Where(payment => payment.Fsp == fspToRemove50).ToList();
            Assert.AreEqual(0, fsp50PaymentsThatShouldNotExist.Count, $"{fspToRemove50} was not removed");

            var fsp1PaymentsThatShouldExist = allFspPayments.Where(payment => payment.Fsp == "FSP 1").ToList();
            Assert.AreEqual(3, fsp1PaymentsThatShouldExist.Count, "FSP 1 was removed");
        }
    }
}
