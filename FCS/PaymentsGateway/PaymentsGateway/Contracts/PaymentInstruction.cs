namespace PaymentsGateway.Contracts
{
    using System;
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentInstruction
    {
        [DataMember]
        public Guid MessageId { get; set; }

        [DataMember]
        public PaymentTransactionInstruction PaymentTransactionInstruction { get; set; }

        [DataMember]
        public PaymentErrorInstruction PaymentErrorInstruction { get; set; }

        [DataMember]
        public PaymentSummaryInstruction PaymentSummaryInstruction { get; set; }
    }
}
