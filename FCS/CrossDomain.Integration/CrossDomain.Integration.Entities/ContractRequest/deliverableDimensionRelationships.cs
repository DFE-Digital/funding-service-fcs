namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(Namespace = "contractrequest")]
    [XmlRoot(Namespace = "contractrequest", IsNullable = true)]
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public class deliverableDimensionRelationships
    {
        public deliverableDimensionRelationships()
        {
            deliverableDimensionRelationship = new List<dimensionRelationshipType>();
        }

        [XmlElement("deliverableDimensionRelationship", Order = 0)]
        public List<dimensionRelationshipType> deliverableDimensionRelationship { get; set; }
    }
}
