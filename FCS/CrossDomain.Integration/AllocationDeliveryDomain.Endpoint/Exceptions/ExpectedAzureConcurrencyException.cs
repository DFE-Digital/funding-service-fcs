namespace AllocationDeliveryDomain.Endpoint.Exceptions
{
    using System;

    public class ExpectedAzureConcurrencyException : Exception
    {
        public ExpectedAzureConcurrencyException()
            : base("Expected Azure concurrency exception used to manage competing consumers")
        {
        }
    }
}
