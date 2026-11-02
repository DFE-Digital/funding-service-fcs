namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class deliverableType
    {
        [XmlElement(Order = 0)]
        public string fundingStreamCode { get; set; }

        [XmlElement(Order = 1)]
        public int deliverableCode { get; set; }

        [XmlElement(Order = 2)]
        public string businessCode { get; set; }

        [XmlElement(Order = 3)]
        public string deliverableName { get; set; }
    }
}