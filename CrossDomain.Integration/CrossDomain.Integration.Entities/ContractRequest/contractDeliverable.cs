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
    public class contractDeliverable
    {
        public contractDeliverable()
        {
            deliverableDimensionRelationships = new List<dimensionRelationshipType>();
            deliverableOrganisationRelationships = new List<organisationRelationshipType>();
            contractDeliverablePeriods = new List<contractDeliverablePeriodType>();
            deliverable= new deliverableType();
        }

        [XmlElement(Order = 0)]
        public string correlationId { get; set; }

        [XmlElement(Order = 1)]
        public deliverableType deliverable { get; set; }

        [XmlArray(Order = 2)]
        [XmlArrayItem("contractDeliverablePeriod", IsNullable = false)]
        public List<contractDeliverablePeriodType> contractDeliverablePeriods { get; set; }

        [XmlArray(Order = 3)]
        [XmlArrayItem("deliverableOrganisationRelationship", IsNullable = false)]
        public List<organisationRelationshipType> deliverableOrganisationRelationships { get; set; }

        [XmlArray(Order = 4)]
        [XmlArrayItem("deliverableDimensionRelationship", IsNullable = false)]
        public List<dimensionRelationshipType> deliverableDimensionRelationships { get; set; }

        [XmlElement(Order = 5)]
        public string deliverableDescription { get; set; }

        [XmlElement(Order = 6)]
        public decimal? unitCost { get; set; }

        [XmlElement(Order = 7)]
        public int? plannedVolume { get; set; }

        [XmlElement(Order = 8)]
        public decimal? plannedValue { get; set; }

        [XmlElement(Order = 9)]
        public bool crmNotPresent { get; set; }

        [XmlAttribute]
        public Intent CRMIntent { get; set; }
    }
}