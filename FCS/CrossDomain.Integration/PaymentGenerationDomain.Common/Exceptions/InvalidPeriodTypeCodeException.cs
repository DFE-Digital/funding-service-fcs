namespace PaymentGenerationDomain.Common.Exceptions
{
    using System;

    public class InvalidPeriodTypeCodeException : Exception
    {
        public InvalidPeriodTypeCodeException()
        {
        }

        public InvalidPeriodTypeCodeException(string message)
            : base(message)
        {
        }
    }
}
