namespace PaymentsGateway.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Common;
    using Contracts;
    using Framework;

    public class PaymentFilesGenerator : IPaymentFilesGenerator
    {
        public ICsvSerializer CsvSerializer { get; set; }

        public IFileManager FileManager { get; set; }

        public ILogger Logger { get; set; }
        
        public bool GenerateFiles(PaymentInstruction paymentInstruction)
        {
            Logger.Log("PaymentFilesGenerator.GenerateFiles method: started", LoggingLevel.Info);

            var paymentFiles = new PaymentFiles() { Files = new List<PaymentFile>() };
            
            // Generate Payment Instruction PaymentFiles
            if (paymentInstruction.PaymentTransactionInstruction != null)
            {
                if (paymentInstruction.PaymentTransactionInstruction.PaymentTransactionInstructionLines.Any())
                {
                    paymentFiles.Files.Add(new PaymentFile
                    {
                        FileName = paymentInstruction.PaymentTransactionInstruction.FileName,
                        Contents = ConvertToCsv(paymentInstruction.PaymentTransactionInstruction.PaymentTransactionInstructionLines)
                    });
                }
            }

            // Generate Summary Instruction PaymentFiles
            if (paymentInstruction.PaymentSummaryInstruction != null)
            {
                if (paymentInstruction.PaymentSummaryInstruction.PaymentSummaryInstructionLines.Any())
                {
                    paymentFiles.Files.Add(new PaymentFile
                    {
                        FileName = paymentInstruction.PaymentSummaryInstruction.FileName,
                        Contents = ConvertToCsv(paymentInstruction.PaymentSummaryInstruction.PaymentSummaryInstructionLines)
                    });                 
                }
            }

            // Generate Error PaymentFiles
            if (paymentInstruction.PaymentErrorInstruction != null)
            {
                if (paymentInstruction.PaymentErrorInstruction.PaymentErrorInstructionLines.Any())
                {
                    paymentFiles.Files.Add(new PaymentFile
                    {
                        FileName = paymentInstruction.PaymentErrorInstruction.FileName,
                        Contents = ConvertToCsv(paymentInstruction.PaymentErrorInstruction.PaymentErrorInstructionLines)
                    });
                }
            }

            try
            {
                FileManager.UploadFiles(paymentFiles, ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"]);
            }
            catch (Exception exception)
            {
                FileManager.DeleteUploadedFiles(paymentFiles, ConfigurationManager.AppSettings["PaymentGateway.FileSharePath"]);

                Logger.Log(string.Format("GenerateFiles method: Filemanager.Uploadfile failed because of this Exception : {0}", exception.Message), LoggingLevel.Error);
                throw;
            }

            Logger.Log("PaymentFilesGenerator.GenerateFiles method: finished", LoggingLevel.Info);

            return true;
        }

        private IEnumerable<string> ConvertToCsv<T>(IEnumerable<T> paymentLines)
        {
            return CsvSerializer.ToCsv(ConfigurationManager.AppSettings["PaymentGateway.CsvDelimiter"], paymentLines, false);
        }
    }
}