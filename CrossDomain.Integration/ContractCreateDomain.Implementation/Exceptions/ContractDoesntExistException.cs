namespace SFA.FCT.ContractCreateDomain.Implementation.Exceptions
{
    using System;

    /// <summary>
    /// Custom exception for throwing when an Contract is not present in the CRM System
    /// </summary>
    public class ContractDoesntExistException : Exception
    {
        public ContractDoesntExistException()
        {
        }

        public ContractDoesntExistException(string message)
            : base(message)
        {
        }
    }
}
