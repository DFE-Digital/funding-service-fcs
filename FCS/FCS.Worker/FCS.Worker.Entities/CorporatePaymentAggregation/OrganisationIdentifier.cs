// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType = true, Namespace = "urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace = "urn:sfa:schemas:paymentsaggregation", IsNullable = false)]
    public class OrgainsationIdentifier
    {
        [XmlElement(Order = 0)]
        public string OrganisationId { get; set; }

        [XmlElement(Order = 1)]
        public OrgainsationIdentifierOrganisationIdentifierName OrganisationIdentifierName { get; set; }
    }
}