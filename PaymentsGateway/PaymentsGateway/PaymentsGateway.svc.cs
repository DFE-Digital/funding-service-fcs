namespace PaymentsGateway
{
    using System;
    using BusinessLogic;
    using Contracts;
    using Framework;

    public class PaymentsGateway : IPaymentsGateway
    {
        public IPaymentFilesGenerator PaymentFilesGenerator { get; set; }

        public ILogger Logger { get; set; }

        public PaymentInstructionResponse GeneratePaymentInstruction(PaymentInstruction paymentInstruction)
        {
            Logger.Log("PaymentsGateway.GeneratePaymentInstruction method: started", LoggingLevel.Info);

            var response = new PaymentInstructionResponse { IsPaymentInstructionCreated = false };

            try
            {
                response.IsPaymentInstructionCreated = PaymentFilesGenerator.GenerateFiles(paymentInstruction);
            }
            catch (Exception exception)
            {
                Logger.Log(string.Format("Payment instructions not Generated because of this Exception {0}", exception.Message), LoggingLevel.Error);
            }

            Logger.Log("PaymentsGateway.GeneratePaymentInstruction method: finished", LoggingLevel.Info);

            return response;
        }
    }
}
