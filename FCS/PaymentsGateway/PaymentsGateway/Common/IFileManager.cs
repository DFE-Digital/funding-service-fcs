namespace PaymentsGateway.Common
{
    using Framework;

    public interface IFileManager
    {
        ILogger Logger { get; set; }

        void UploadFiles(PaymentFiles paymentFiles, string filePath);

        void DeleteFile(PaymentFile paymentFile, string filePath);

        void DeleteUploadedFiles(PaymentFiles paymentFiles, string filePath);
    }
}
