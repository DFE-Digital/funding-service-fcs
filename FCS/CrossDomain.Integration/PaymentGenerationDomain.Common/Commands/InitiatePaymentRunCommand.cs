namespace PaymentGenerationDomain.Common.Commands
{
    using System;
    using PaymentGenerationDomain.Integration.DataStore.Model;

    public class InitiatePaymentRunCommand
    {
        public PaymentTimetable PaymentTimetable { get; set; }
    }
}
