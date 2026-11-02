namespace PaymentsGateway.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using BusinessLogic;
    using Common;
    using Contracts;
    using Framework;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class IntegrationTests
    {
        private const string SummaryCsvFileName = "PSummay.txt";
        private const string TransactionCsvFileName = "PTransaction.txt";
        private const string ErrorCsvFileName = "PError.txt";

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

            var paymentTransactionInstructionLine = new PaymentInstructionLine
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

        [TestMethod, TestCategory("IntegrationTest-ONHOLD")]
        public void PaymentGateway_ShouldGenerateThreeCsvFiles()
        {
            List<string> loggerMessages = new List<string>();

            var loggerMock = new Mock<ILogger>();
            loggerMock.Setup(l => l.Log(It.IsAny<string>(), LoggingLevel.Error)).Callback((string message, LoggingLevel level) => loggerMessages.Add(message)); 
            var logger = loggerMock.Object;
            //var logger = new EntLibLogger();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = logger,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = new CsvSerializer() { Logger = logger },
                        FileManager = new FileManager() { Logger = logger },
                        Logger = logger
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = SetPaymentSummaryInstruction(),
                PaymentTransactionInstruction = SetPaymentTransactionInstruction(),
                PaymentErrorInstruction = SetPaymentErrorInstruction()
            };
            
            var respsose = paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            if (!respsose.IsPaymentInstructionCreated)
            {
                string message = loggerMessages.Aggregate("GeneratePaymentInstruction failed: ", (current, logMessage) => current + logMessage);

                Assert.Fail(message);
            }

            Assert.IsTrue(respsose.IsPaymentInstructionCreated, "GeneratePaymentInstruction reported that files where not created");

            Assert.IsTrue(File.Exists(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], SummaryCsvFileName)), "Summary File is missing after Payment generation run");
            Assert.IsTrue(File.Exists(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], TransactionCsvFileName)), "Transaction File is missing after Payment generation run");
            Assert.IsTrue(File.Exists(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], ErrorCsvFileName)), "Error File is missing after Payment generation run");

            //TODO: Test Cleanup not working 
            TestCleanup();
        }

        [TestCleanup]
        private void TestCleanup()
        {
            File.Delete(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], SummaryCsvFileName));
            File.Delete(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], TransactionCsvFileName));
            File.Delete(Path.Combine(ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"], ErrorCsvFileName));
        }
    }
}
