namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO.PaymentGeneration
{
    using System;

    public class PaymentTimetable
    {
        public string FundingStreamPeriodCode { get; set; }

        public string CalendarPeriod { get; set; }

        public string Status { get; set; }

        public string CalendarPeriodType { get; set; }

        public DateTime CensusEndDate { get; set; }

        public string FinancialPeriod { get; set; }
        
        public string FinancialPeriodType { get; set; }
        
        public DateTime PeriodStartDate { get; set; }
        
        public DateTime PeriodEndDate { get; set; }

        public DateTime PaymentDueDate { get; set; }

        public string LinkCodeSuffix { get; set; }
    }
}
