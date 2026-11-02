namespace OrganisationDomain.Implementation.BusinessExceptions
{
    using System;

    public class DuplicateUkprnProviderException : Exception
    {
        public DuplicateUkprnProviderException()
        {
        }

        public DuplicateUkprnProviderException(string message)
            : base(message)
        {
        }

        public DuplicateUkprnProviderException(string message, Exception inner)
            : base(message, inner)
        {
        }
    }
}
