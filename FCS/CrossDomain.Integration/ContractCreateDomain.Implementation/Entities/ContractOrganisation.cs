namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System.Diagnostics.CodeAnalysis;
    using System.Xml.Serialization;

    [ExcludeFromCodeCoverage]
    [XmlRoot("contract", Namespace = "contractrequest", IsNullable = false)]
    public class ContractOrganisation
    {
        public const string ContracteeType = "CONTRACTEE";

        ////[XmlElement("organisationIdentifier")]
        ////[CrmMapping("sfa_OrganisationID", CrmLookupType.Organisation)]
        public string OrganisationId { get; set; }

        /// <summary>
        /// This property maps to two fields in a contract "sfa_providername"
        /// </summary>
        [XmlElement("ukprn", Namespace = "contract")]
        [CrmMapping("sfa_ukprn")]
        public string UKPRN { get; set; }

        /// <summary>
        /// This property maps to "sfa_providername"
        /// </summary>
        [CrmMapping("sfa_providername", CrmLookupType.Organisation)]
        // ReSharper disable once InconsistentNaming
        public string UKPRN_MAPPED
        {
            get { return UKPRN; }
        }

        // this is not a field in the Contract Entity at the moment
        [XmlElement("contractOrganisationRelationshipType")]
        public string Type { get; set; }

        // Properties used for the Organisation service.
        // Staus of the organisation?
        [XmlElement("organisationStatus")]
        public string Status { get; set; }

        // Organisation name
        [XmlElement("legalName", Namespace = "contract")]
        public string Name { get; set; }

        public string Upin { get; set; }

        public string CompanyNumber { get; set; }

        public string CharityNumber { get; set; }

        public Address Address { get; set; } = new Address();
    }
}
