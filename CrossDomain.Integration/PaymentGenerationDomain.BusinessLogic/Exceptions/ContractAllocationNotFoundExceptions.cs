namespace PaymentGenerationDomain.BusinessLogic.Exceptions
{
    using System;

    public class ContractAllocationNotFoundException : Exception
    {
            public ContractAllocationNotFoundException()
            {
            }

            public ContractAllocationNotFoundException(string message)
                : base(message)
            {
            }

            public ContractAllocationNotFoundException(string message, Exception inner)
                : base(message, inner)
            {
            }
    }
}
