namespace FCTCrmConfig.ConfigPackage
{
    using System.Xml.Serialization;

    public class XrmContractNumber
    {
        [XmlElement("ContractNumberType")]
        public XrmContractNumberType Type { get; set; }

        [XmlElement("Agency")]
        public string Agency { get; set; }

        [XmlElement("FundingTypeCode")]
        public string FundingTypeCode { get; set; }

        [XmlElement("FundingStream")]
        public string FundingStream { get; set; }

        [XmlElement("LastNumber")]
        public int LastNumber { get; set; }

        [XmlElement("Name")]
        public string Name { get; set; }

    }
}