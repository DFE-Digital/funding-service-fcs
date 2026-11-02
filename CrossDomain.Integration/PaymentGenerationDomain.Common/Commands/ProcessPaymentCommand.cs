namespace PaymentGenerationDomain.Common.Commands
{
    using System;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    
    public class ProcessPaymentRunCommand
    {
        ////public string FundingStreamPeriodCode { get; set; }

        ////public string CalendarPeriod { get; set; }

        ////public DateTime CensusEndDate { get; set; }

        ////public DateTime DueDate { get; set; }

        public PaymentTimetable PaymentTimetable { get; set; }
    }
}
