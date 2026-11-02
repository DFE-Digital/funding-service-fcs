namespace OrganisationDomain.Implementation.DataObjects
{
    using System.Xml.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class CpdsProvider
    {
        public organisation ChangedOrganisation { get; set; }

        public int SequenceNumber { get; set; }

        public XDocument ChangedProvider { get; set; }
    }
}
