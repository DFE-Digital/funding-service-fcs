namespace OrganisationDomain.Implementation.BusinessExceptions
{
    using System;

    public class OrganisationCorporateSchemaValidationFailedException : Exception
    {
        public OrganisationCorporateSchemaValidationFailedException()
        {
        }

        public OrganisationCorporateSchemaValidationFailedException(string message)
            : base(message)
        {
        }

        public OrganisationCorporateSchemaValidationFailedException(string message, Exception inner)
            : base(message, inner)
        {
        }
    }
}
