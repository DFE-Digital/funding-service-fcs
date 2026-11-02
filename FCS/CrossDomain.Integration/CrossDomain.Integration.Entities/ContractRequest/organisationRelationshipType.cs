namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class organisationRelationshipType
    {
        [XmlElement("organisationRelationshipType", Order = 0)]
        public string organisationRelationshipType1 { get; set; }

        [XmlElement(Order = 1)]
        public int organisationIdentifier { get; set; }
    }
}