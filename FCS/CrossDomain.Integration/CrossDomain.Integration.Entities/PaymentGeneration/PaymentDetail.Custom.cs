namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentGeneration
{
    using System.Xml.Serialization;

    public partial class PaymentDetail
    {
        [XmlIgnore]
        public string CodaAccountCode { get; set; }

        [XmlIgnore]
        public string ControlAccountCode { get; set; }

        [XmlIgnore]
        public string Element1Code { get; set; }

        [XmlIgnore]
        public string DummyAccountCode { get; set; }
    }
}
