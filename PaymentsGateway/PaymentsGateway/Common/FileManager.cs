namespace PaymentsGateway.Common
{
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using Framework;

    public class FileManager : IFileManager
    {
        public ILogger Logger { get; set; }

        public void UploadFiles(PaymentFiles paymentFiles, string filePath)
        {
            Logger.Log("FileManager.UploadFilesUploadFiles method: started", LoggingLevel.Info);

            foreach (var paymentFile in paymentFiles.Files)
            {
                File.WriteAllLines(Path.Combine(filePath, paymentFile.FileName), paymentFile.Contents);
                paymentFile.IsFileCreated = true;
            }

            Logger.Log("FileManager.UploadFilesUploadFiles method: finished", LoggingLevel.Info);
        }

        public void DeleteFile(PaymentFile paymentFile, string filePath)
        {
            Logger.Log("FileManager.DeleteFile method: started", LoggingLevel.Info);

            File.Delete(Path.Combine(filePath, paymentFile.FileName));

            Logger.Log("FileManager.DeleteFile method: finished", LoggingLevel.Info);
        }

        public void DeleteUploadedFiles(PaymentFiles paymentFiles, string filePath)
        {
            Logger.Log("FileManager.DeleteUploadedFiles method: started", LoggingLevel.Info);

            foreach (var paymentFile in paymentFiles.Files.Where(paymentFile => paymentFile.IsFileCreated))
            {
                File.Delete(Path.Combine(filePath, paymentFile.FileName));
            }

            Logger.Log("FileManager.DeleteUploadedFiles method: finished", LoggingLevel.Info);
        }
    }
}