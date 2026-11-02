namespace OrganisationDomain.Integration.Messages.Dtos
{
    public class OrgSupplementaryDataDto
    {
        public int Ukprn { get; set; }

        public string CompanyNumber { get; set; }

        public string CharityNumber { get; set; }
        public OrgSupplementaryAddressDto LegalAddress { get; set; }
    }
}