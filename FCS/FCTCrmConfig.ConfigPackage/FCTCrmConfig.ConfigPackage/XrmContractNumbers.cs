namespace FCTCrmConfig.ConfigPackage
{
    using System.Collections.Generic;
    using System.Xml.Serialization;

    [XmlRoot("ContractNumbers")]
    public class XrmContractNumbers
    {
        [XmlElement("ContractNumber")]
        public List<XrmContractNumber> ContractNumbers { get; set; }
    }
}