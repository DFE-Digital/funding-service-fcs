namespace PaymentsGateway.Contracts
{
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentSummaryInstructionLine
    {
        [DataMember]
        public string PaymentFileType { get; set; }

        [DataMember]
        public string PaymentFileName { get; set; }

        [DataMember]
        public int NumberOfPayments { get; set; }

        [DataMember]
        public string TotalPaymentAmount { get; set; }

        [DataMember]
        public string ErrorFileName { get; set; }

        [DataMember]
        public int NumberOfPaymentsInError { get; set; }

        [DataMember]
        public string TotalPaymentAmountInError { get; set; }
    }
}
