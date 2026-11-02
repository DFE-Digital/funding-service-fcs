// ReSharper disable CheckNamespace
namespace SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Xml.Serialization;

    [Serializable]
    [XmlType(AnonymousType=true, Namespace="urn:sfa:schemas:paymentsaggregation")]
    [XmlRoot(Namespace="urn:sfa:schemas:paymentsaggregation", IsNullable=false)]
    public class Organisation
    {
        public Organisation()
        {
            AlternativeOrganisationIdentifiers = new List<OrgainsationIdentifier>();
        }
        
        [XmlElement(Order=0)]
        public string MainOrganisationIdentifier { get; set; }

        [XmlArray(Order=1)]
        [XmlArrayItem("OrgainsationIdentifier", IsNullable=false)]
        public List<OrgainsationIdentifier> AlternativeOrganisationIdentifiers { get; set; }

        public string GetUkprn()
        {
            return AlternativeOrganisationIdentifiers
                .Single(id => id.OrganisationIdentifierName == OrgainsationIdentifierOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                .OrganisationId;
        }
    }
}