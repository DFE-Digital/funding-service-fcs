namespace PaymentsGateway.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Common;
    using Contracts;
    using Framework;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    /// <summary>
    /// Summary description for CsvSerialiser
    /// </summary>
    [TestClass]
    public class CsvSerialiser
    {
        private const string SummaryCsvFileName = "PSummay.txt";
        private const string TransactionCsvFileName = "PTransaction.txt";
        private const string ErrorCsvFileName = "PError.txt";

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        #region Test Setup

        private PaymentSummaryInstruction SetPaymentSummaryInstruction()
        {
            var paymentSummaryInstruction = new PaymentSummaryInstruction { FileName = SummaryCsvFileName };

            var paymentSummaryInstructionLines = new List<PaymentSummaryInstructionLine>();

            var paymentSummaryInstructionLine = new PaymentSummaryInstructionLine
            {
                PaymentFileType = "Control",
                ErrorFileName = ErrorCsvFileName,
                NumberOfPayments = 2,
                NumberOfPaymentsInError = 1,
                PaymentFileName = TransactionCsvFileName,
                TotalPaymentAmount = "12345.67",
                TotalPaymentAmountInError = "111.11"
            };

            paymentSummaryInstructionLines.Add(paymentSummaryInstructionLine);
            paymentSummaryInstruction.PaymentSummaryInstructionLines = paymentSummaryInstructionLines;
            return paymentSummaryInstruction;
        }

        private PaymentTransactionInstruction SetPaymentTransactionInstruction()
        {
            var paymentTransactionInstruction = new PaymentTransactionInstruction { FileName = TransactionCsvFileName };

            var paymentTransactionInstructionLines = new List<PaymentInstructionLine>();

            var paymentTransactionInstructionLine = new PaymentInstructionLine()
            {
                Amount = "12345.67",
                CompanyCode = "1234",
                Date = "10/10/2014",
                Dc = 1234,
                Desc = "Desc",
                Doc = "Doc",
                DocLineNo = 12,
                DueDate = "10/10/2014",
                Element1 = string.Empty,
                Element2 = string.Empty,
                Element3 = string.Empty,
                Element4 = string.Empty,
                Element5 = string.Empty,
                Element6 = string.Empty,
                Element7 = string.Empty,
                Element8 = string.Empty,
                Extref1 = string.Empty,
                Extref2 = string.Empty,
                Extref3 = string.Empty,
                Extref4 = string.Empty,
                Extref5 = string.Empty,
                Extref6 = string.Empty,
                LineType = 2,
                LinkCode = "789",
                Num = 1254,
                Period = "Period",
                Tax = "Tax",
                Year = "2008"
            };

            paymentTransactionInstructionLines.Add(new PaymentInstructionLine
            {
                Amount = "12345.67",
                CompanyCode = "1234",
                Date = "10/10/2014",
                Dc = 1234,
                Desc = "Desc",
                Doc = "Doc",
                DocLineNo = 12,
                DueDate = "10/10/2014",
                Element1 = string.Empty,
                Element2 = string.Empty,
                Element3 = string.Empty,
                Element4 = string.Empty,
                Element5 = string.Empty,
                Element6 = string.Empty,
                Element7 = string.Empty,
                Element8 = string.Empty,
                Extref1 = string.Empty,
                Extref2 = string.Empty,
                Extref3 = string.Empty,
                Extref4 = string.Empty,
                Extref5 = string.Empty,
                Extref6 = string.Empty,
                LineType = 2,
                LinkCode = "789",
                Num = 1254,
                Period = "Period",
                Tax = "Tax",
                Year = "2008"
            });
            paymentTransactionInstructionLines.Add(paymentTransactionInstructionLine);
            paymentTransactionInstruction.PaymentTransactionInstructionLines = paymentTransactionInstructionLines;
            return paymentTransactionInstruction;
        }

        private PaymentErrorInstruction SetPaymentErrorInstruction()
        {
            var paymentErrorInstruction = new PaymentErrorInstruction { FileName = ErrorCsvFileName };

            var paymentErrorInstructionLines = new List<PaymentInstructionLine>();

            var paymentErrorInstructionLine = new PaymentInstructionLine()
            {
                Amount = "12345.67",
                CompanyCode = "1234",
                Date = "10/10/2014",
                Dc = 1234,
                Desc = "Desc",
                Doc = "Doc",
                DocLineNo = 12,
                DueDate = "10/10/2014",
                Element1 = string.Empty,
                Element2 = string.Empty,
                Element3 = string.Empty,
                Element4 = string.Empty,
                Element5 = string.Empty,
                Element6 = string.Empty,
                Element7 = string.Empty,
                Element8 = string.Empty,
                Extref1 = string.Empty,
                Extref2 = string.Empty,
                Extref3 = string.Empty,
                Extref4 = string.Empty,
                Extref5 = string.Empty,
                Extref6 = string.Empty,
                LineType = 2,
                LinkCode = "789",
                Num = 1254,
                Period = "Period",
                Tax = "Tax",
                Year = "2008"
            };

            paymentErrorInstructionLines.Add(paymentErrorInstructionLine);
            paymentErrorInstruction.PaymentErrorInstructionLines = paymentErrorInstructionLines;
            return paymentErrorInstruction;
        }
        #endregion

        [TestMethod, TestCategory("UnitTest")]
        public void CsvSerialisershouldReturnDataInSpecificFormat()
        {
            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = SetPaymentSummaryInstruction(),
                PaymentTransactionInstruction = SetPaymentTransactionInstruction(),
                PaymentErrorInstruction = SetPaymentErrorInstruction()
            };

            var csvSerializer = new CsvSerializer { Logger = new Mock<ILogger>().Object };


            var errorCsv = csvSerializer.ToCsv(ConfigurationManager.AppSettings["PaymentGateway.CsvDelimiter"], paymentInstruction.PaymentErrorInstruction.PaymentErrorInstructionLines, false);
            var summaryCsv = csvSerializer.ToCsv(ConfigurationManager.AppSettings["PaymentGateway.CsvDelimiter"], paymentInstruction.PaymentSummaryInstruction.PaymentSummaryInstructionLines, false);
            var transactionsCsv = csvSerializer.ToCsv(ConfigurationManager.AppSettings["PaymentGateway.CsvDelimiter"], paymentInstruction.PaymentTransactionInstruction.PaymentTransactionInstructionLines, false);

            Assert.AreEqual(transactionsCsv.First(), "789,1234,,,,,,,,,2008,Period,10/10/2014,12345.67,1234,2,Doc,Desc,10/10/2014,Tax,,,,,,,1254,12", "PaymentTransactionInstruction Csv format incorrect");
            Assert.AreEqual(errorCsv.First(), "789,1234,,,,,,,,,2008,Period,10/10/2014,12345.67,1234,2,Doc,Desc,10/10/2014,Tax,,,,,,,1254,12", "PaymentErrorInstruction Csv format incorrect");
            Assert.AreEqual(summaryCsv.First(), "Control,PTransaction.txt,2,12345.67,PError.txt,1,111.11", "PaymentSummaryInstruction Csv format incorrect");
        }
    }
}
