namespace SFA.FCT.CrossDomain.Integration.Common.Exceptions
{
    using System;

    public class ContractValidationException : Exception
    {
        public ContractValidationException(string message) : base(message)
        {
        }

        public ContractValidationException(string message, Exception innerException) : base(message, innerException)
        {
        }
    }
}
