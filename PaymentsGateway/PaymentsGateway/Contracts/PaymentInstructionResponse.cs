namespace PaymentsGateway.Contracts
{
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentInstructionResponse
    {
        [DataMember]
        public bool IsPaymentInstructionCreated  { get; set; }
    }
}