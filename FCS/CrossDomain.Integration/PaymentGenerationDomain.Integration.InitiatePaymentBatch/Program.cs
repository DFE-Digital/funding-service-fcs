namespace PaymentGenerationDomain.Integration.InitiatePaymentBatch
{
    using System;
    using System.Threading.Tasks;
    using Common.Commands;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    class Program
    {
        static async Task Main()
        {
            Console.WriteLine("InitiatePaymentGenerationBatch web job started.");

            Console.WriteLine("Sending InitiatePaymentBatchCommand");

            await EndpointBuilder.CreateSendOnlyEndpoint<InitiatePaymentBatchCommand>()
                .Send("PaymentGenerationDomain.InitiatePaymentBatch", new InitiatePaymentBatchCommand());

            Console.WriteLine("Sending CreatePaymentSummaryReportCommand");

            await EndpointBuilder.CreateSendOnlyEndpoint<CreatePaymentSummaryReportCommand>()
                .Send("Operations.PaymentSummary", new CreatePaymentSummaryReportCommand());

            Console.WriteLine("InitiatePaymentGenerationBatch web job complete.");
        }
    }
}
