namespace PaymentsGateway.Contracts
{
    using System.Collections.Generic;
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentSummaryInstruction
    {
        [DataMember]
        public string FileName { get; set; }

        [DataMember]
        public List<PaymentSummaryInstructionLine> PaymentSummaryInstructionLines { get; set; }
    }
}
