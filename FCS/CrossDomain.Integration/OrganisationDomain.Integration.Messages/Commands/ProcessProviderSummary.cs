namespace OrganisationDomain.Integration.Messages.Commands
{
    public class ProcessProviderSummary : BaseUpdateOrganisationCommand
    {
        // change data type, add properties as necessary
        // public List<ProviderSequence> ProviderSummary { get; set; }
        public byte[] ProviderSummaryDatabus { get; set; }
    }
}
