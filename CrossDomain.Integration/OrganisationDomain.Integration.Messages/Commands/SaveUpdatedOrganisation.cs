namespace OrganisationDomain.Integration.Messages.Commands
{
using System.Xml.Linq;

    public class SaveUpdatedOrganisation : BaseUpdateOrganisationCommand
    {
        public XDocument ChangedProvider { get; set; }
    }
}
