namespace OrganisationDomain.Integration.Messages.Commands
{
using System.Xml.Linq;

    public class ProcessOrganisationDetails : BaseUpdateOrganisationCommand
    {
        public XDocument ChangedProvider { get; set; }
    }
}
