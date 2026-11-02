namespace PaymentsGateway
{
    using System.ServiceModel;
    using Contracts;

    [ServiceContract]
    public interface IPaymentsGateway
    {
        [OperationContract]
        PaymentInstructionResponse GeneratePaymentInstruction(PaymentInstruction paymentInstruction);
    }   
}
