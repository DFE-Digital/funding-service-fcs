namespace OrganisationDomain.Implementation.Exceptions
{
    using System;

    public class ProviderSummaryUnavailableException : Exception
    {
        public ProviderSummaryUnavailableException()
        {
        }

        public ProviderSummaryUnavailableException(string message)
            : base(message)
        {
        }

        public ProviderSummaryUnavailableException(string message, Exception inner)
            : base(message, inner)
        {
        }
    }
}