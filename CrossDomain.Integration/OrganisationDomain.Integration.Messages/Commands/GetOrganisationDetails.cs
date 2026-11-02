namespace OrganisationDomain.Integration.Messages.Commands
{
    public class GetOrganisationDetails : BaseUpdateOrganisationCommand
    {
        public int Ukprn { get; set; }

        public int Upin { get; set; }
    }
}
