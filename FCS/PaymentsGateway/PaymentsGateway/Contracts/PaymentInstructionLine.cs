namespace PaymentsGateway.Contracts
{
    using System.Runtime.Serialization;

    [DataContract]
    public class PaymentInstructionLine
    {
        [DataMember]
        public string LinkCode { get; set; }

        [DataMember]
        public string CompanyCode { get; set; }

        [DataMember]
        public string Element1 { get; set; }

        [DataMember]
        public string Element2 { get; set; }

        [DataMember]
        public string Element3 { get; set; }

        [DataMember]
        public string Element4 { get; set; }

        [DataMember]
        public string Element5 { get; set; }

        [DataMember]
        public string Element6 { get; set; }

        [DataMember]
        public string Element7 { get; set; }

        [DataMember]
        public string Element8 { get; set; }

        [DataMember]
        public string Year { get; set; }

        [DataMember]
        public string Period { get; set; }

        [DataMember]
        public string Date { get; set; }

        [DataMember]
        public string Amount { get; set; }

        [DataMember]
        public int Dc { get; set; }

        [DataMember]
        public int LineType { get; set; }

        [DataMember]
        public string Doc { get; set; }

        [DataMember]
        public string Desc { get; set; }

        [DataMember]
        public string DueDate { get; set; }

        [DataMember]
        public string Tax { get; set; }

        [DataMember]
        public string Extref1 { get; set; }

        [DataMember]
        public string Extref2 { get; set; }

        [DataMember]
        public string Extref3 { get; set; }

        [DataMember]
        public string Extref4 { get; set; }

        [DataMember]
        public string Extref5 { get; set; }

        [DataMember]
        public string Extref6 { get; set; }

        [DataMember]
        public int Num { get; set; }

        [DataMember]
        public int DocLineNo { get; set; }
    }
}