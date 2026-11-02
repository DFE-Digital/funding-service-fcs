namespace SFA.FCT.ContractCreateDomain.Implementation.Exceptions
{
    using System;

    /// <summary>
    /// Custom exception for throwing when an Organisation is already present in the CRM System
    /// </summary>
    public class OrganisationDoesntExistException : Exception
    {
        public OrganisationDoesntExistException()
        {
        }

        public OrganisationDoesntExistException(string message)
            : base(message)
        {
        }
    }
}
