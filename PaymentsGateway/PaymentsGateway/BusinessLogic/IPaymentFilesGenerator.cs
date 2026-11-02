namespace PaymentsGateway.BusinessLogic
{
    using Common;
    using Contracts;
    using Framework;

    public interface IPaymentFilesGenerator
    {
        ICsvSerializer CsvSerializer { get; set; }

        IFileManager FileManager { get; set; }

        ILogger Logger { get; set; }

        bool GenerateFiles(PaymentInstruction paymentInstruction);
    }
}
