namespace SFA.FCT.ContractCreateDomain.Implementation.Exceptions
{
    using System;

    /// <summary>
    /// Custom exception for throwing when an Duplicate Contract Exists in the CRM System
    /// </summary>
    public class DuplicateContractException : Exception
    {
        public DuplicateContractException()
        {
        }

        public DuplicateContractException(string message)
            : base(message)
        {
        }
    }
}
