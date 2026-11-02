namespace SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule
{
    using System.Collections.Generic;
    using System.Xml.Serialization;

    public class Organisation
    {
        public Organisation()
        {
            OrganisationIdentifiers = new List<OrganisationIdentifier>();
        }

        public string MainOrganisationIdentifier { get; set; }

        [XmlArrayItem("OrganisationIdentifier", IsNullable = false)]
        public List<OrganisationIdentifier> OrganisationIdentifiers { get; set; }
    }
}