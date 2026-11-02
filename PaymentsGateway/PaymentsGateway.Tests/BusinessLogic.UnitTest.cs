namespace PaymentsGateway.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using BusinessLogic;
    using Common;
    using Contracts;
    using Framework;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;

    [TestClass]
    public class BusinessLogicUnitTest
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

        #region Tests

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldCallCsvSerializerMethodOnceForEachTypeOfPaymentFile()
        {
            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };
            
            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = SetPaymentSummaryInstruction(),
                PaymentTransactionInstruction = SetPaymentTransactionInstruction(),
                PaymentErrorInstruction = SetPaymentErrorInstruction()
            };
            

            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), paymentInstruction.PaymentTransactionInstruction.PaymentTransactionInstructionLines,false), Times.Once, "ToCsv for PaymentTransactionInstructionLines is not called exactly once");
            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), paymentInstruction.PaymentSummaryInstruction.PaymentSummaryInstructionLines, false), Times.Once, "ToCsv for PaymentSummaryInstructionLines is not called exactly once");
            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), paymentInstruction.PaymentErrorInstruction.PaymentErrorInstructionLines, false), Times.Once, "ToCsv for PaymentErrorInstructionLines is not called exactly once");
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldCall_DeleteUploadedFilesMethodWhenUploadFiles_ThrowsException()
        {

            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = SetPaymentSummaryInstruction(),
                PaymentTransactionInstruction = SetPaymentTransactionInstruction(),
                PaymentErrorInstruction = SetPaymentErrorInstruction()
            };
            
            var exception = new Exception("Exception was thrown");

            fileManagerMock.Setup(x => x.UploadFiles(It.IsAny<PaymentFiles>(), ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"])).Throws(exception);

            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            fileManagerMock.Verify(m => m.DeleteUploadedFiles(It.IsAny<PaymentFiles>(), ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"]), Times.Once, "DeleteUploadedFiles is not called after exception thrown by UploadFiles");

        }


        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentTransactionInstructionIsNull()
        {

            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = null,
                PaymentTransactionInstruction = null,
                PaymentErrorInstruction = null
            };
            
            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentInstructionLine>>(), false), Times.Never, "ToCsv for PaymentInstructionLines should not be called if PaymentInstruction is null");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentSummaryInstructionIsNull()
        {

            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = null,
                PaymentTransactionInstruction = null,
                PaymentErrorInstruction = null
            };
            
            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentSummaryInstructionLine>>(), false), Times.Never, "ToCsv for PaymentSummaryInstructionLines should not be called if SummaryInstruction is null");
            
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentErrorInstructionIsNull()
        {

            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = null,
                PaymentTransactionInstruction = null,
                PaymentErrorInstruction = null
            };
            
            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentInstructionLine>>(), false), Times.Never, "ToCsv for PaymentErrorInstruction should not be called if PaymentInstruction is null");


        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentTransactionInstructionLinesHasNoItems()
        {
            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = null,
                PaymentTransactionInstruction = new PaymentTransactionInstruction() { PaymentTransactionInstructionLines = new List<PaymentInstructionLine>() },
                PaymentErrorInstruction = null
            };

            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentInstructionLine>>(), false), Times.Never, "ToCsv for PaymentTransactionInstruction should not be called if PaymentInstructionLine has no data");


        }
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentSummaryInstructionLinesHasNoItems()
        {
            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = new PaymentSummaryInstruction() { PaymentSummaryInstructionLines = new List<PaymentSummaryInstructionLine>() },
                PaymentTransactionInstruction = null,
                PaymentErrorInstruction = null
            };
            
            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentSummaryInstructionLine>>(), false), Times.Never, "ToCsv for PaymentSummaryInstruction should not be called if PaymentSummaryInstructionLine has no data");


        }
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentGateway_ShouldNotCallCsvSerializerMethodIfPaymentErrorInstructionLinesHasNoItems()
        {

            var loggerMock = new Mock<ILogger>();
            var csvSerializerMock = new Mock<ICsvSerializer>();
            var fileManagerMock = new Mock<IFileManager>();

            var paymentsGateway = new PaymentsGateway
            {
                Logger = loggerMock.Object,
                PaymentFilesGenerator =
                    new PaymentFilesGenerator
                    {
                        CsvSerializer = csvSerializerMock.Object,
                        FileManager = fileManagerMock.Object,
                        Logger = loggerMock.Object
                    }
            };

            var paymentInstruction = new PaymentInstruction
            {
                PaymentSummaryInstruction = null,
                PaymentTransactionInstruction = null,
                PaymentErrorInstruction = new PaymentErrorInstruction() { PaymentErrorInstructionLines = new List<PaymentInstructionLine>() }
            };

            paymentsGateway.GeneratePaymentInstruction(paymentInstruction);

            csvSerializerMock.Verify(m => m.ToCsv(It.IsAny<string>(), It.IsAny<IEnumerable<PaymentInstructionLine>>(), false), Times.Never, "ToCsv for PaymentErrorInstruction should not be called if PaymentInstructionLine has no data");
        }
       

        #endregion

    }


}
