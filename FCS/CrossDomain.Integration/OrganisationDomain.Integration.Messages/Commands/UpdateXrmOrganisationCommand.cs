namespace OrganisationDomain.Integration.Messages.Commands
{
    using Dtos;

    public class UpdateXrmOrganisationCommand
    {
        public string Ukprn { get; set;  }

        public string CompanyNumber { get; set; }

        public string CharityNumber { get; set; }

        public OrgSupplementaryAddressDto Address { get; set; }

        public override string ToString()
        {
            return $"Ukprn: {Ukprn}, CompanyNumber: {CompanyNumber}, CharityNumber: {CharityNumber}";
        }
    }
}