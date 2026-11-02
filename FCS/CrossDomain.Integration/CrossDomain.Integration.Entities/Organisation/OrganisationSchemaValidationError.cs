namespace SFA.FCT.CrossDomain.Integration.Entities.Organisation
{
    public class OrganisationSchemaValidationError
    {
        public int LineNumber { get; set; }

        public int LinePosition { get; set; }

        public string ErrorMessage { get; set; }
    }
}
