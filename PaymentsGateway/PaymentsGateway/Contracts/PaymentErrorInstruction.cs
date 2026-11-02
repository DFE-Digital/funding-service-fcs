namespace PaymentsGateway.Contracts
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentErrorInstruction
    {
        [DataMember]
        public string FileName { get; set; }

        [DataMember]
        public List<PaymentInstructionLine> PaymentErrorInstructionLines { get; set; }
    }
}
