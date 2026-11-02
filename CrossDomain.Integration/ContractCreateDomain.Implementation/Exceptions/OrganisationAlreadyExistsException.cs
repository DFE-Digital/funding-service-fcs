namespace SFA.FCT.ContractCreateDomain.Implementation.Exceptions
{
    using System;

    /// <summary>
    /// Custom exception for throwing when an Organisation is already present in the CRM System
    /// </summary>
    public class OrganisationAlreadyExistsException : Exception
    {
        public OrganisationAlreadyExistsException()
        {
        }

        public OrganisationAlreadyExistsException(string message)
            : base(message)
        {
        }
    }
}
