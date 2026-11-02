namespace FCT.Operations.Tests.PaymentSummary
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Services;

    [TestClass]
    public class ExcelGeneratorTests
    {
        PaymentSummaryReportService service = new PaymentSummaryReportService(null, null);

        [TestMethod, TestCategory("UnitTest")]
        public void ExcelGeneratorTest_ShouldGetWorkBook()
        {
            ExcelGenerator excelGenerator = new ExcelGenerator();

            // act
            var workbook = excelGenerator.GenerateWorkbook(new PaymentSummaryLine[0], new PaymentSummaryLine[0], new ReportingPeriod(new DateTime(2020, 12, 02)), service);

            Assert.IsNotNull(workbook);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ExcelGeneratorTest_ShouldGetWorkBookWithTheRightNumberOfRows()
        {
            // arrange
            ExcelGenerator excelGenerator = new ExcelGenerator();
            List<PaymentSummaryLine> paymentSummaryLines = new List<PaymentSummaryLine>
            {
                new PaymentSummaryLine(122, "Some p","", new List<FspPayment>
                {
                    new FspPayment("FSP3", 10,""),
                    new FspPayment("FSP2", 20,""),
                    new FspPayment("FSP1", 20,""),
                    new FspPayment("FSP4", -122,""),
                }),
                new PaymentSummaryLine(124, "Some p4","", new List<FspPayment>
                {
                    new FspPayment("FSP1", 11, ""),
                    new FspPayment("FSP2", 22,""),
                    new FspPayment("FSP3", -10, ""),
                    new FspPayment("FSP4", -124, ""),
                }),
                new PaymentSummaryLine(125, "Some p5","", new List<FspPayment>
                {
                    new FspPayment("FSP3", 11, ""),
                    new FspPayment("FSP2", 22, ""),
                    new FspPayment("FSP1", -11, ""),
                    new FspPayment("FSP4", -125, ""),
                }),
                new PaymentSummaryLine(128, "Some p2","", new List<FspPayment>
                {
                    new FspPayment("FSP3", 11,""),
                    new FspPayment("FSP2", 22, ""),
                    new FspPayment("FSP1", -11, ""),
                    new FspPayment("FSP4", -128, ""),
                }),
            };

            // act
            var workbook = excelGenerator.GenerateWorkbook(paymentSummaryLines, paymentSummaryLines, new ReportingPeriod(new DateTime(2020, 6, 15)), service);

            //workbook.Save("Test2.xlsx");
            Assert.IsNotNull(workbook);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ExcelGeneratorTest_ShouldGetWorkBookLikeStoryWorkbookSample()
        {
            // arrange
            ExcelGenerator excelGenerator = new ExcelGenerator();
            List<PaymentSummaryLine> paymentSummaryLines = new List<PaymentSummaryLine>
            {
                new PaymentSummaryLine(80000001, "PROVIDER 1","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", -100,""),
                    new FspPayment("FSP 3", -100,""),
                    new FspPayment("FSP 2", 600,""),
                }),
                new PaymentSummaryLine(80000003, "PROVIDER 3","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 500,""),
                    new FspPayment("FSP 3", 0,""),
                    new FspPayment("FSP 2", -500,""),
                }),
                new PaymentSummaryLine(80000002, "PROVIDER 2","", new List<FspPayment>
                {
                    new FspPayment("FSP 1", 1000000,""),
                    new FspPayment("FSP 3", 0,""),
                    new FspPayment("FSP 2", -100,""),
                }),
            };

            // act
            var workbook = excelGenerator.GenerateWorkbook(paymentSummaryLines, paymentSummaryLines, new ReportingPeriod(new DateTime(2020, 5, 15)), service);


            //workbook.Save($"Test_{Guid.NewGuid()}.xlsx");
            Assert.IsNotNull(workbook);
        }
    }
}
