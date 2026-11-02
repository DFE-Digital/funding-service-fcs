namespace OrganisationDomain.Integration.Messages.Commands
{
    using System.Collections.Generic;
    using Entities;

    public class ProcessUpdatedOrganisations : BaseUpdateOrganisationCommand
    {
        public List<ProviderSequence> ChangedProviderUkprnList { get; set; }
    }
}
