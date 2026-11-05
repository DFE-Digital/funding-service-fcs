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
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class deliverableOrganisationRelationships
    {
        public deliverableOrganisationRelationships()
        {
            deliverableOrganisationRelationship = new List<organisationRelationshipType>();
        }

        [XmlElement("deliverableOrganisationRelationship", Order = 0)]
        public List<organisationRelationshipType> deliverableOrganisationRelationship { get; set; }
    }
}