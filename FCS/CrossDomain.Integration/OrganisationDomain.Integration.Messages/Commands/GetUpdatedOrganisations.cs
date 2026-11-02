namespace OrganisationDomain.Integration.Messages.Commands
{
    public class GetUpdatedOrganisations : BaseUpdateOrganisationCommand
    {
        // change data type, add properties as necessary
        public byte[] ProviderSummaryDatabus { get; set; }
    }
}
