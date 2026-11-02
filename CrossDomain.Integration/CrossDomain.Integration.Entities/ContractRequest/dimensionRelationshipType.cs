namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class dimensionRelationshipType
    {
        [XmlElement(Order = 0)]
        public string dimensionName { get; set; }

        [XmlElement(Order = 1)]
        public string dimensionValue { get; set; }
    }
}