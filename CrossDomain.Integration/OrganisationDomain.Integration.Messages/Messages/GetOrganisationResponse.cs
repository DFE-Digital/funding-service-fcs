namespace OrganisationDomain.Integration.Messages.Messages
{
    using SFA.FCT.CrossDomain.Integration.Entities;
    public class GetOrganisationResponse
    {
        public organisation Organisation { get; set; }

        public bool DuplicatesFound  { get; set; }

        public bool OrganisationXmlIsInvalidAgainstSchema { get; set; }
    }
}
